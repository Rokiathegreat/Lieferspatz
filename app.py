import os

from flask import (
    Flask,

    g,

    render_template,

    request,

    redirect,

    url_for,

    session,

    jsonify
)


import json

import sqlite3

from datetime import datetime


# Get current directory
current_dir = os.getcwd()

# Construct the relative path to the database file
database_path = os.path.join(current_dir, "DeliverySparrowDataBase.db")

# Update the DATABASE variable with the relative path
DATABASE = database_path


# Create the Flask application
app = Flask(__name__)
app.static_folder = 'static'
app.secret_key = 'your_secret_key_here'  # Make sure to set a secret key for session management
app.config['SECRET_KEY'] = 'your_strong_secret_key'  # Replace with a secure key


# Database connection function
def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
        db.row_factory = sqlite3.Row
    return db
    
#Decorator
@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()


@app.route('/')
def home():

    if 'customer_email' in session:
        return redirect(url_for('show_restaurants'))
    elif 'restaurant_name' in session:
        return redirect(url_for('restaurant_dashboard'))
    else:
        return render_template('home.html')


@app.route('/customer/login', methods=['GET', 'POST'])
def customer_login():

    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']  

        db = get_db()
        user = db.execute('SELECT * FROM Customer WHERE EMAIL = ? AND PASSWORD = ?', (email, password)).fetchone()
        
        if user:
            session['customer_email'] = user['EMAIL'] 
            session['customer_zip_code'] = user['ZIP_CODE']  
            return redirect(url_for('show_restaurants'))
        else:
            return 'Invalid email or password', 401 #redirect to home, error

    return render_template('customer_login.html')

                          
@app.route('/show_restaurants', methods=['GET'])
def show_restaurants():
    customer_zip_code = session.get('customer_zip_code', None) 
    
    if not customer_zip_code: 
        return redirect(url_for('customer_login'))

    db = get_db()
    current_time = datetime.now().strftime('%H:%M:%S')  # time in HH:MM:SS format

    query = """
    SELECT * FROM Restaurant
    WHERE ? BETWEEN opening_time AND closing_time
    AND ZIP_CODES LIKE ?
    """
    restaurants = db.execute(query, (current_time, '%' + customer_zip_code + '%')).fetchall()

    
    return render_template('restaurants.html', restaurants=restaurants)


@app.route('/restaurant/menu/<string:restaurant_name>', methods=['GET'])
def show_menu(restaurant_name):
    db = get_db()
    restaurant = db.execute('SELECT * FROM Restaurant WHERE name = ?', (restaurant_name,)).fetchone()
    if restaurant:
        menu_items = db.execute('SELECT * FROM Item WHERE restaurant_name = ?', (restaurant_name,)).fetchall()
        
        # Extract unique categories from menu items
        categories = {item['category'] for item in menu_items}

        # Pass the categories along with other data to the template
        return render_template('menu.html', menu_items=menu_items, categories=categories, restaurant=restaurant, customer_email=session['customer_email'])
    else:
        return 'Restaurant not found', 404


@app.route('/process_cart', methods=['POST'])
def process_cart():
    try:
        # Extract form data
        cart_data = request.form.get('cart_data')
        restaurant_name = request.form.get('restaurant_name')
        customer_email = request.form.get('customer_email')  # Assuming the customer's email is stored in session or form
        total_price = request.form.get('total_price')
        customer_notes = request.form.get('customer_notes')

        # Validate and parse cart data from JSON
        try:
            cart_items = json.loads(cart_data)
        except json.JSONDecodeError as e:
            raise ValueError('Invalid JSON format for cart_data')

        # Validate other form data as needed

        # Connect to the database
        db = get_db()
        cursor = db.cursor() #?

        try:
            # Insert into OrderC table
            cursor.execute('''
                INSERT INTO OrderC (Restaurant_NAME, TOTAL_PRICE, Customer_EMAIL, STATUS, Customer_Notes)
                VALUES (?, ?, ?, 'Cart', ?)
            ''', (restaurant_name, total_price, customer_email, customer_notes))
            order_nr = cursor.lastrowid #gets the newly generated order_nr

            # Insert items into order_items table
            for item in cart_items:
                cursor.execute('''
                    INSERT INTO order_items (order_number, item_name, quantity, total_price)
                    VALUES (?, ?, ?, ?)
                ''', (order_nr, item['item_name'], item['quantity'], item['total_price']))  #from cart_items fron cart_data
                
            db.commit()
            # Redirect to a confirmation page with the order number
            return jsonify({'success': True, 'order_nr': order_nr})

        except Exception as e:
            if db:
                db.rollback()
            return jsonify({'success': False, 'error_message': str(e)})

    except ValueError as e:
        return jsonify({'success': False, 'error_message': str(e)})

    finally:
        if 'db' in g: 
            g.db.close()

def get_order_details(order_nr):
    db = get_db()
    cur = db.cursor()
    cur.execute('SELECT * FROM OrderC WHERE Order_Nr = ?', (order_nr,))
    order_details = cur.fetchone()
    return order_details

def get_order_items(order_nr):
    db = get_db()
    cur = db.cursor()
    cur.execute('SELECT * FROM order_items WHERE order_number = ?', (order_nr,))
    order_items = cur.fetchall()
    return order_items


@app.route('/order_confirmation/<int:order_nr>')
def order_confirmation(order_nr):
    order_details = get_order_details(order_nr)
    order_items = get_order_items(order_nr)

    if order_details:
        return render_template('order_confirmation.html', order=order_details, items=order_items)
    else:
        return "Order not found", 404

@app.route('/customer_orders')
def customer_orders():
    customer_email = session.get('customer_email')  # Example of getting customer email from session
    
    db = get_db()
    orders = db.execute('SELECT * FROM OrderC WHERE Customer_EMAIL = ? ORDER BY order_time_column DESC', (customer_email,)).fetchall()

    return render_template('customer_orders.html', orders=orders)



@app.route('/confirm_order/<int:order_nr>', methods=['POST'])
def confirm_order(order_nr):
    try:
        db = get_db()
        db.execute('UPDATE OrderC SET STATUS = ? WHERE Order_Nr = ?', ('In Process', order_nr))
        db.commit()
        return jsonify({'success': True})
    except Exception as e:
        return jsonify({'success': False, 'error_message': str(e)})
		

@app.route('/view_cart', methods=['POST'])
def view_cart():
    cart = session.get('cart', {})
    if not cart:
        return redirect(url_for('show_menu'))

    user_email = session.get('user_email', 'default@email.com') 
    order_nr = save_cart_to_database(cart, user_email)

    return redirect(url_for('cart_review', order_nr=order_nr))





def save_cart_to_database(cart, user_email):
    db = get_db()
    cursor = db.cursor()

    # Insert into OrderC
    cursor.execute('INSERT INTO OrderC (Customer_EMAIL, STATUS) VALUES (?, ?)', (user_email, 'cart'))
    order_nr = cursor.lastrowid  # AUTOINCREMENT is used for Order_Nr

    # Insert items into order_items
    for item_name, details in cart.items():
        cursor.execute('INSERT INTO order_items (order_number, item_name, quantity, total_price) VALUES (?, ?, ?, ?)',
                       (order_nr, item_name, details['quantity'], details['price'] * details['quantity']))
    db.commit()

    return order_nr

@app.route('/customer/register', methods=['GET', 'POST'])
def customer_register():
    if request.method == 'POST':
        # Extract form data
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        email = request.form['email']
        address = request.form['address']
        zip_code = request.form['zip_code']
        password = request.form['password']
            
        # Insert into Customer table
        db = get_db()
        db.execute(
            'INSERT INTO Customer (FIRST_NAME, LAST_NAME, EMAIL, ADDRESS, ZIP_CODE, PASSWORD) VALUES (?, ?, ?, ?, ?, ?)',
            (first_name, last_name, email, address, zip_code, password)
        )
        db.commit()
        
        return redirect(url_for('customer_login'))
    
    return render_template('customer_register.html')


@app.route('/restaurant/register', methods=['GET', 'POST'])
def restaurant_register():
    if request.method == 'POST':
        # Extract form data
        name = request.form['name']
        email = request.form['email']
        address = request.form['address']
        zip_code = request.form['zip_code']
        password = request.form['password']
        description = request.form['description']
        opening_time = request.form['opening_time']
        closing_time = request.form['closing_time']
        zip_codes = request.form['zip_codes']
        photo = request.form['photo']

        # Insert into Restaurant table
        db = get_db()
        db.execute(
            'INSERT INTO Restaurant (NAME, EMAIL, ADDRESS, ZIP_CODE, PASSWORD, DESCRIPTION, OPENING_TIME, CLOSING_TIME, ZIP_CODES, PHOTO) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            (name, email, address, zip_code, password, description, opening_time, closing_time, zip_codes, photo)
        )
        db.commit()
            
        # Redirect to login or another appropriate page
        return redirect(url_for('restaurant_login'))
        
    return render_template('restaurant_register.html')


@app.route('/restaurant/login', methods=['GET', 'POST'])
def restaurant_login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        db = get_db()
        restaurant = db.execute('SELECT * FROM Restaurant WHERE email = ? AND password = ?', (email, password)).fetchone()
        if restaurant:
            # Set the restaurant_name session variable
            session['restaurant_name'] = restaurant['name']
            
            # Log the restaurant in
            return redirect(url_for('restaurant_dashboard'))  # Placeholder for actual route
        else:
            return 'Invalid email or password', 401
    return render_template('restaurant_login.html')



@app.route('/restaurant/manage_orders', methods=['GET'])
def manage_orders():
    # Get the restaurant name from the session
    restaurant_name = session.get('restaurant_name') #[restaurant_name] for session? keep it consistent
    
    # Establish database connection
    db = get_db()
    
    # Query the database for orders, excluding those with status 'Cart'
    orders = db.execute(
        'SELECT * FROM OrderC WHERE restaurant_name = ? AND STATUS != ? ORDER BY Order_time_column DESC',
        (restaurant_name, 'Cart')
    ).fetchall()

    # Pass the restaurant name, status values, and orders to the template
    return render_template('manage_orders.html', restaurant_name=restaurant_name, orders=orders)
  

@app.route('/restaurant/view_order_items/<int:order_nr>', methods=['GET'])
def view_order_items(order_nr):
    # Retrieve the order items for the specified order from the database
    db = get_db()
    order_items = db.execute('SELECT * FROM order_items WHERE order_number = ?', (order_nr,)).fetchall()

    # Pass the order items to a template for displaying them
    return render_template('view_order_items.html', order_items=order_items)



@app.route('/restaurant/update_order_status/<int:order_nr>', methods=['POST'])
def update_order_status(order_nr):
    new_status = request.form['new_status']  # Change 'status' to 'new_status'
    
    
    db = get_db()  
    db.execute('UPDATE OrderC SET STATUS = ? WHERE Order_Nr = ?', (new_status, order_nr))
    db.commit()
    
    return redirect(url_for('manage_orders'))


@app.route('/restaurant/manage_menu_items', methods=['GET', 'POST'])
def manage_menu_items():
    restaurant_name = session.get('restaurant_name')
    
    # Query the database using the restaurant name
    db = get_db()
    menu_items = db.execute('SELECT ITEM_NAME, DESCRIPTION, PREIS, CATEGORY, PHOTO FROM Item WHERE RESTAURANT_NAME = ?', (restaurant_name,)).fetchall()
    
    return render_template('manage_menu_items.html', menu_items=menu_items, restaurant_name=restaurant_name)


@app.route('/restaurant/dashboard', methods=['GET'])
def restaurant_dashboard():
    # Fetch restaurant information from the database
    db = get_db()
    restaurant_data = db.execute('SELECT NAME, DESCRIPTION, PHOTO FROM Restaurant WHERE NAME = ?', (session['restaurant_name'],)).fetchone()

    if restaurant_data:
        # Get the values from the database query result
        restaurant_name = restaurant_data['NAME']
        restaurant_description = restaurant_data['DESCRIPTION']
        restaurant_photo = restaurant_data['PHOTO']
    

    # Pass the data to the template
    return render_template('restaurant_dashboard.html',
                           restaurant_name=restaurant_name,
                           restaurant_description=restaurant_description,
                           restaurant_photo=restaurant_photo)


@app.route('/restaurant/update_menu_item/<item_name>', methods=['GET', 'POST'])
def update_menu_item(item_name):
    if request.method == 'POST':
        new_name = request.form['name']
        new_restaurant_name = request.form['restaurant_name']
        new_price = float(request.form['preis']) 
        new_description = request.form['description']
        new_category = request.form['category']
        new_photo = request.form['photo']

        
        db = sqlite3.connect(DATABASE)
        cursor = db.cursor()
        cursor.execute('UPDATE Item SET ITEM_NAME = ?, RESTAURANT_NAME = ?, PREIS = ?, DESCRIPTION = ?, CATEGORY = ?, PHOTO = ? WHERE ITEM_NAME = ?', (new_name, new_restaurant_name, new_price, new_description, new_category, new_photo, item_name))
        db.commit()
        db.close()

        return redirect(url_for('manage_menu_items'))

    
    db = sqlite3.connect(DATABASE)
    cursor = db.cursor()
    cursor.execute('SELECT ITEM_NAME, RESTAURANT_NAME, PREIS, DESCRIPTION, CATEGORY, PHOTO FROM Item WHERE ITEM_NAME = ?', (item_name,))
    item_data = cursor.fetchone()
    db.close()

    if item_data:
        item_name = item_data[0] #item_name = item_data[ITEM_NAME]
        item_restaurant_name = item_data[1]
        item_price = item_data[2]
        item_description = item_data[3]
        item_category = item_data[4]
        item_photo = item_data[5]


    return render_template('update_menu_item.html',
                           item_name=item_name,
                           item_restaurant_name=item_restaurant_name,
                           item_price=item_price,
                           item_description=item_description,
                           item_category=item_category,
                           item_photo=item_photo)


                           
@app.route('/restaurant/delete_menu_item/<item_name>', methods=['GET', 'POST'])
def delete_menu_item(item_name):
    if request.method == 'POST':

        db = get_db()
        db.execute('DELETE FROM Item WHERE ITEM_NAME = ? AND RESTAURANT_NAME = ?',
                   (item_name, session['restaurant_name'])) #try without restaurant_name
        db.commit()

        return redirect(url_for('manage_menu_items'))

    return render_template('confirm_delete_menu_item.html', item_name=item_name)



@app.route('/restaurant/add_menu_item', methods=['POST'])
def add_menu_item():
    if request.method == 'POST':

        name = request.form['name']
        description = request.form['description']
        price = request.form['price']
        category = request.form['category']
        photo = request.form['photo']  

        # Add the new menu item to the our db
        db = get_db()
        db.execute('INSERT INTO Item (ITEM_NAME, RESTAURANT_NAME, PREIS, DESCRIPTION, CATEGORY, PHOTO) VALUES (?, ?, ?, ?, ?, ?)',
                   (name, session['restaurant_name'], price, description, category, photo))
        db.commit()

        return redirect(url_for('manage_menu_items'))


@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('home'))  


if __name__ == '__main__':
    app.run(debug=True)
