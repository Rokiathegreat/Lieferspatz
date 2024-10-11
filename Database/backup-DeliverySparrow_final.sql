--Command to create new database
--C:\softwares\sqlite\sqlite3 C:\softwares\sqlite\DeliverySparrowDataBase.db < C:\softwares\sqlite\backup-DeliverySparrow_final.sql
--
--Create tables and test data
PRAGMA foreign_keys=OFF; --try without
BEGIN TRANSACTION;
CREATE TABLE Customer (
    FIRST_NAME TEXT NOT NULL,
    LAST_NAME TEXT NOT NULL,
    EMAIL TEXT PRIMARY KEY,
    ADDRESS TEXT NOT NULL,
    ZIP_CODE TEXT NOT NULL,
    PASSWORD TEXT NOT NULL
);
INSERT INTO Customer VALUES('Anna','Schmidt','anna@gmail.com','Dusseldorf','40210','x123');
INSERT INTO Customer VALUES('Max','Muller','max@gmail.com','Neuss','41460','x123');
INSERT INTO Customer VALUES('Sophie','Becker','sophie@gmail.com','Ratingen','40878','x123');
INSERT INTO Customer VALUES('Lukas','Fischer','lukas@gmail.com','Krefeld','47798','x123');
INSERT INTO Customer VALUES('Emma','Weber','emma@gmail.com','Moers','47441','x123');
CREATE TABLE Restaurant (
    NAME TEXT PRIMARY KEY, 
    EMAIL TEXT NOT NULL,
    ADDRESS TEXT NOT NULL,
    ZIP_CODE INT, -- could also be text to compare with delivery radius 
    PASSWORD TEXT NOT NULL,
    DESCRIPTION TEXT,
    OPENING_TIME TEXT NOT NULL,
    CLOSING_TIME TEXT NOT NULL,
    ZIP_CODES TEXT NOT NULL,	
    PHOTO TEXT
);
INSERT INTO Restaurant VALUES('Burger King','bk@gmail.com','Dusseldorf',40213,'x123','Home of the Whopper','00:00:00','23:59:59','41460,40213,40214','burger_king.jpg');
INSERT INTO Restaurant VALUES('Pizza Hut','ph@gmail.com','Neuss',41462,'x123','Delicious Pizza Varieties','00:00:00','23:59:59','41460,41461','pizza_hut.jpg');
INSERT INTO Restaurant VALUES('Sushi Express','sushi@gmail.com','Ratingen',40879,'x123','Fresh and Authentic Sushi','14:00:00','20:00:00','40878,40879','sushi_express.jpg');
INSERT INTO Restaurant VALUES('Steakhouse Deluxe','steak@gmail.com','Krefeld',47799,'x123','Premium Cuts and Steaks','17:00:00','23:00:00','47798,47799','steakhouse_deluxe.jpg');
INSERT INTO Restaurant VALUES('Cafe Paris','cafe@gmail.com','Moers',47442,'x123','Charming French Cafe','08:00:00','18:00:00','47440,47441','cafe_paris.jpg');
INSERT INTO Restaurant VALUES('Pasta Palace','pasta@gmail.com','Duisburg',45680,'x123','Authentic Italian Pasta','11:00:00','21:00:00','45679,45680','pasta_palace.jpg');
INSERT INTO Restaurant VALUES('Vegetarian Haven','veg@gmail.com','Essen',12346,'x123','Wholesome Vegetarian Delights','09:00:00','20:00:00','12345,12346','vegetarian_haven.jpg');
INSERT INTO Restaurant VALUES('Mexican Fiesta','mexican@gmail.com','Muelheim',45479,'x123','Spicy and Flavorful Mexican Cuisine','12:00:00','22:00:00','45478,45479','mexican_fiesta.jpg');
INSERT INTO Restaurant VALUES('Indian Spice','indian@gmail.com','Schloss',45679,'x123','Rich and Spiced Indian Dishes','13:00:00','21:00:00','45678,45679','indian_spice.jpg');
INSERT INTO Restaurant VALUES('Thai Delight','thai@gmail.com','Essen',12347,'x123','Authentic Thai Flavors','15:00:00','23:00:00','12345,12347','thai_delight.jpg');
CREATE TABLE Item (
    ITEM_NAME TEXT PRIMARY KEY, --again NOT NULL
    RESTAURANT_NAME TEXT NOT NULL,
    PREIS NUMERIC(5, 2) NOT NULL, --999.99
    DESCRIPTION TEXT NOT NULL,
    CATEGORY TEXT NOT NULL,
    PHOTO TEXT,
    CONSTRAINT Item_FK FOREIGN KEY (RESTAURANT_NAME) REFERENCES Restaurant(NAME)
);
INSERT INTO Item VALUES('Whopper','Burger King',8.99,'Classic flame-grilled burger','Burger','whopper.jpg');
INSERT INTO Item VALUES('Chicken Royale','Burger King',7.49,'Crispy chicken sandwich','Chicken','chicken_royale.jpg');
INSERT INTO Item VALUES('BK Double Cheeseburger','Burger King',6.99,'Double patty with cheese','Burger','double_cheeseburger.jpg');
INSERT INTO Item VALUES('Fries','Burger King',2.99,'Golden crispy fries','Sides','fries.jpg');
INSERT INTO Item VALUES('Onion Rings','Burger King',3.49,'Deep-fried onion rings','Sides','onion_rings.jpg');
INSERT INTO Item VALUES('Chocolate Shake','Burger King',4.99,'Rich chocolate milkshake','Beverage','chocolate_shake.jpg');
INSERT INTO Item VALUES('Apple Pie','Burger King',2.49,'Warm apple-filled pastry','Dessert','apple_pie.jpg');
INSERT INTO Item VALUES('Grilled Chicken Salad','Burger King',5.99,'Healthy grilled chicken salad','Salad','grilled_chicken_salad.jpg');
INSERT INTO Item VALUES('Vanilla Soft Serve','Burger King',1.99,'Creamy vanilla soft-serve','Dessert','vanilla_soft_serve.jpg');
INSERT INTO Item VALUES('Iced Coffee','Burger King',3.99,'Chilled iced coffee','Beverage','iced_coffee.jpg');
INSERT INTO Item VALUES('Pepperoni Pizza','Pizza Hut',10.99,'Classic pepperoni pizza','Pizza','pepperoni_pizza.jpg');
INSERT INTO Item VALUES('Margherita Pizza','Pizza Hut',9.49,'Traditional margherita pizza','Pizza','margherita_pizza.jpg');
INSERT INTO Item VALUES('Hawaiian Pizza','Pizza Hut',11.99,'Pineapple and ham pizza','Pizza','hawaiian_pizza.jpg');
INSERT INTO Item VALUES('Garlic Bread','Pizza Hut',4.99,'Toasty garlic bread','Sides','garlic_bread.jpg');
INSERT INTO Item VALUES('Caesar Salad','Pizza Hut',6.99,'Crisp Caesar salad','Salad','caesar_salad.jpg');
INSERT INTO Item VALUES('Tiramisu Hut','Pizza Hut',5.99,'Classic Italian dessert','Dessert','tiramisu.jpg');
INSERT INTO Item VALUES('Chicken Alfredo Pasta','Pizza Hut',8.99,'Creamy chicken alfredo pasta','Pasta','chicken_alfredo_pasta.jpg');
INSERT INTO Item VALUES('Buffalo Wings','Pizza Hut',7.49,'Spicy buffalo wings','Appetizer','buffalo_wings.jpg');
INSERT INTO Item VALUES('Cheese Sticks','Pizza Hut',3.99,'Cheesy breadsticks','Sides','cheese_sticks.jpg');
INSERT INTO Item VALUES('Italian Gelato','Pizza Hut',4.49,'Smooth Italian gelato','Dessert','italian_gelato.jpg');
INSERT INTO Item VALUES('Sushi Combo A','Sushi Express',12.99,'Assorted sushi rolls','Sushi','sushi_combo_a.jpg');
INSERT INTO Item VALUES('Sashimi Platter','Sushi Express',14.49,'Fresh sashimi slices','Sushi','sashimi_platter.jpg');
INSERT INTO Item VALUES('Tempura Udon','Sushi Express',10.99,'Udon noodles with tempura','Noodles','tempura_udon.jpg');
INSERT INTO Item VALUES('Edamame','Sushi Express',3.99,'Steamed soybeans','Appetizer','edamame.jpg');
INSERT INTO Item VALUES('Miso Soup','Sushi Express',2.49,'Savory miso soup','Soup','miso_soup.jpg');
INSERT INTO Item VALUES('Dragon Roll','Sushi Express',15.99,'Dragon-shaped sushi roll','Sushi','dragon_roll.jpg');
INSERT INTO Item VALUES('Green Tea Ice Cream','Sushi Express',4.99,'Refreshing green tea ice cream','Dessert','green_tea_ice_cream.jpg');
INSERT INTO Item VALUES('Rainbow Roll','Sushi Express',13.49,'Colorful sushi roll','Sushi','rainbow_roll.jpg');
INSERT INTO Item VALUES('Salmon Teriyaki','Sushi Express',11.99,'Grilled salmon with teriyaki sauce','Main Course','salmon_teriyaki.jpg');
INSERT INTO Item VALUES('Spicy Tuna Roll','Sushi Express',9.49,'Spicy tuna sushi roll','Sushi','spicy_tuna_roll.jpg');
INSERT INTO Item VALUES('T-Bone Steak','Steakhouse Deluxe',25.99,'Juicy T-bone steak','Steak','t_bone_steak.jpg');
INSERT INTO Item VALUES('Filet Mignon','Steakhouse Deluxe',29.99,'Tender filet mignon','Steak','filet_mignon.jpg');
INSERT INTO Item VALUES('BBQ Ribs','Steakhouse Deluxe',18.99,'Succulent BBQ ribs','Ribs','bbq_ribs.jpg');
INSERT INTO Item VALUES('Loaded Baked Potato','Steakhouse Deluxe',6.99,'Potato with cheese and bacon','Sides','loaded_baked_potato.jpg');
INSERT INTO Item VALUES('Caesar Salad with Grilled Shrimp','Steakhouse Deluxe',12.99,'Classic Caesar salad with grilled shrimp','Salad','caesar_salad_grilled_shrimp.jpg');
INSERT INTO Item VALUES('Cheeseburger','Steakhouse Deluxe',14.49,'Cheese-covered burger','Burger','cheeseburger.jpg');
INSERT INTO Item VALUES('Chocolate Brownie Sundae','Steakhouse Deluxe',8.99,'Decadent chocolate brownie with ice cream','Dessert','chocolate_brownie_sundae.jpg');
INSERT INTO Item VALUES('Garlic Butter Mushrooms','Steakhouse Deluxe',5.99,'Sauteed mushrooms with garlic butter','Appetizer','garlic_butter_mushrooms.jpg');
INSERT INTO Item VALUES('Grilled Asparagus','Steakhouse Deluxe',7.49,'Fresh asparagus spears','Vegetables','grilled_asparagus.jpg');
INSERT INTO Item VALUES('New York Cheesecake','Steakhouse Deluxe',9.99,'Creamy New York-style cheesecake','Dessert','new_york_cheesecake.jpg');
INSERT INTO Item VALUES('Croissant','Cafe Paris',2.99,'Flaky and buttery croissant','Pastry','croissant.jpg');
INSERT INTO Item VALUES('Quiche Lorraine','Cafe Paris',7.99,'Savory quiche with bacon and cheese','Quiche','quiche_lorraine.jpg');
INSERT INTO Item VALUES('Cafe au Lait','Cafe Paris',3.49,'Classic French coffee with milk','Beverage','cafe_au_lait.jpg');
INSERT INTO Item VALUES('French Onion Soup','Cafe Paris',5.99,'Rich and flavorful onion soup','Soup','french_onion_soup.jpg');
INSERT INTO Item VALUES('Ratatouille','Cafe Paris',9.49,'Traditional French vegetable stew','Main Course','ratatouille.jpg');
INSERT INTO Item VALUES('Macarons','Cafe Paris',8.99,'Assorted French macarons','Dessert','macarons.jpg');
INSERT INTO Item VALUES('Crostini with Brie','Cafe Paris',6.49,'Toasted bread with melted Brie','Appetizer','crostini_with_brie.jpg');
INSERT INTO Item VALUES('Eclair','Cafe Paris',4.99,'Classic chocolate eclair','Dessert','eclair.jpg');
INSERT INTO Item VALUES('Salade Nicoise','Cafe Paris',10.99,'Mixed salad with tuna and olives','Salad','salade_nicoise.jpg');
INSERT INTO Item VALUES('Pain Perdu','Cafe Paris',7.49,'French toast with syrup and berries','Dessert','pain_perdu.jpg');
INSERT INTO Item VALUES('Spaghetti Bolognese','Pasta Palace',11.99,'Spaghetti with meat sauce','Pasta','spaghetti_bolognese.jpg');
INSERT INTO Item VALUES('Fettuccine Alfredo','Pasta Palace',10.99,'Creamy fettuccine pasta','Pasta','fettuccine_alfredo.jpg');
INSERT INTO Item VALUES('Lasagna','Pasta Palace',12.99,'Layered pasta with meat and cheese','Pasta','lasagna.jpg');
INSERT INTO Item VALUES('Garlic Breadsticks','Pasta Palace',4.99,'Garlic-flavored breadsticks','Sides','garlic_breadsticks.jpg');
INSERT INTO Item VALUES('Caprese Salad','Pasta Palace',8.49,'Tomato, mozzarella, and basil salad','Salad','caprese_salad.jpg');
INSERT INTO Item VALUES('Tortellini Carbonara','Pasta Palace',13.49,'Tortellini in creamy carbonara sauce','Pasta','tortellini_carbonara.jpg');
INSERT INTO Item VALUES('Minestrone Soup','Pasta Palace',5.99,'Hearty vegetable soup','Soup','minestrone_soup.jpg');
INSERT INTO Item VALUES('Penne Arrabbiata','Pasta Palace',9.99,'Penne pasta in spicy tomato sauce','Pasta','penne_arrabbiata.jpg');
INSERT INTO Item VALUES('Gnocchi with Pesto','Pasta Palace',7.49,'Potato dumplings in basil pesto','Pasta','gnocchi_with_pesto.jpg');
INSERT INTO Item VALUES('Tiramisu','Pasta Palace',6.99,'Classic Italian dessert','Dessert','tiramisu_pasta_palace.jpg');
INSERT INTO Item VALUES('Vegetarian Burger','Vegetarian Haven',9.99,'Plant-based burger patty','Burger','vegetarian_burger.jpg');
INSERT INTO Item VALUES('Mushroom Risotto','Vegetarian Haven',12.49,'Creamy risotto with mushrooms','Risotto','mushroom_risotto.jpg');
INSERT INTO Item VALUES('Vegan Pizza','Vegetarian Haven',11.99,'Pizza with vegan cheese and veggies','Pizza','vegan_pizza.jpg');
INSERT INTO Item VALUES('Sweet Potato Fries','Vegetarian Haven',5.99,'Baked sweet potato fries','Sides','sweet_potato_fries.jpg');
INSERT INTO Item VALUES('Quinoa Salad','Vegetarian Haven',8.99,'Healthy quinoa salad','Salad','quinoa_salad.jpg');
INSERT INTO Item VALUES('Hummus Platter','Vegetarian Haven',7.49,'Assorted hummus with pita','Appetizer','hummus_platter.jpg');
INSERT INTO Item VALUES('Stuffed Bell Peppers','Vegetarian Haven',10.99,'Bell peppers stuffed with rice and veggies','Main Course','stuffed_bell_peppers.jpg');
INSERT INTO Item VALUES('Vegan Chocolate Cake','Vegetarian Haven',6.99,'Rich vegan chocolate cake','Dessert','vegan_chocolate_cake.jpg');
INSERT INTO Item VALUES('Avocado Toast','Vegetarian Haven',4.99,'Toasted bread with avocado spread','Appetizer','avocado_toast.jpg');
INSERT INTO Item VALUES('Green Smoothie','Vegetarian Haven',3.99,'Refreshing green smoothie','Beverage','green_smoothie.jpg');
INSERT INTO Item VALUES('Tacos Al Pastor','Mexican Fiesta',10.99,'Marinated pork tacos','Tacos','tacos_al_pastor.jpg');
INSERT INTO Item VALUES('Burrito Bowl','Mexican Fiesta',12.49,'Rice, beans, and toppings in a bowl','Burrito','burrito_bowl.jpg');
INSERT INTO Item VALUES('Quesadilla','Mexican Fiesta',8.99,'Cheese-filled tortilla','Quesadilla','quesadilla.jpg');
INSERT INTO Item VALUES('Guacamole and Chips','Mexican Fiesta',6.99,'Fresh guacamole with tortilla chips','Appetizer','guacamole_and_chips.jpg');
INSERT INTO Item VALUES('Enchiladas','Mexican Fiesta',11.99,'Rolled tortillas with meat and sauce','Enchiladas','enchiladas.jpg');
INSERT INTO Item VALUES('Churros','Mexican Fiesta',4.49,'Crispy fried dough with cinnamon sugar','Dessert','churros.jpg');
INSERT INTO Item VALUES('Mexican Street Corn','Mexican Fiesta',7.99,'Grilled corn with mayo and spices','Appetizer','mexican_street_corn.jpg');
INSERT INTO Item VALUES('Margarita','Mexican Fiesta',8.49,'Classic lime margarita','Beverage','margarita.jpg');
INSERT INTO Item VALUES('Tres Leches Cake','Mexican Fiesta',9.99,'Moist three-milk cake','Dessert','tres_leches_cake.jpg');
INSERT INTO Item VALUES('Salsa Verde Chicken','Mexican Fiesta',10.49,'Chicken in green salsa','Main Course','salsa_verde_chicken.jpg');
INSERT INTO Item VALUES('Chicken Tikka Masala','Indian Spice',13.99,'Grilled chicken in creamy tomato sauce','Chicken','chicken_tikka_masala.jpg');
INSERT INTO Item VALUES('Vegetable Biryani','Indian Spice',11.49,'Flavorful rice with mixed vegetables','Biryani','vegetable_biryani.jpg');
INSERT INTO Item VALUES('Paneer Butter Masala','Indian Spice',12.99,'Paneer in rich buttery tomato sauce','Paneer','paneer_butter_masala.jpg');
INSERT INTO Item VALUES('Garlic Naan','Indian Spice',3.99,'Flatbread with garlic flavor','Bread','garlic_naan.jpg');
INSERT INTO Item VALUES('Aloo Gobi','Indian Spice',9.99,'Potato and cauliflower curry','Vegetarian','aloo_gobi.jpg');
INSERT INTO Item VALUES('Samosa','Indian Spice',5.49,'Crispy pastry filled with spiced potatoes','Appetizer','samosa.jpg');
INSERT INTO Item VALUES('Mango Lassi','Indian Spice',4.99,'Refreshing mango yogurt drink','Beverage','mango_lassi.jpg');
INSERT INTO Item VALUES('Chicken Korma','Indian Spice',14.49,'Chicken in creamy nut sauce','Chicken','chicken_korma.jpg');
INSERT INTO Item VALUES('Dal Tadka','Indian Spice',8.99,'Yellow lentils with tempered spices','Vegetarian','dal_tadka.jpg');
INSERT INTO Item VALUES('Gulab Jamun','Indian Spice',6.99,'Sweet fried dumplings in sugar syrup','Dessert','gulab_jamun.jpg');
INSERT INTO Item VALUES('Pad Thai','Thai Delight',12.99,'Stir-fried rice noodles with shrimp','Noodles','pad_thai.jpg');
INSERT INTO Item VALUES('Green Curry Chicken','Thai Delight',13.49,'Chicken in aromatic green curry','Chicken','green_curry_chicken.jpg');
INSERT INTO Item VALUES('Tom Yum Soup','Thai Delight',6.99,'Spicy and sour soup with shrimp','Soup','tom_yum_soup.jpg');
INSERT INTO Item VALUES('Mango Sticky Rice','Thai Delight',5.99,'Sweet mango with sticky rice','Dessert','mango_sticky_rice.jpg');
INSERT INTO Item VALUES('Pineapple Fried Rice','Thai Delight',10.49,'Fried rice with pineapple and cashews','Rice','pineapple_fried_rice.jpg');
INSERT INTO Item VALUES('Spring Rolls','Thai Delight',4.99,'Crispy spring rolls with dipping sauce','Appetizer','spring_rolls.jpg');
INSERT INTO Item VALUES('Thai Iced Tea','Thai Delight',3.49,'Sweet and creamy iced tea','Beverage','thai_iced_tea.jpg');
INSERT INTO Item VALUES('Massaman Curry Beef','Thai Delight',14.99,'Beef in rich massaman curry','Beef','massaman_curry_beef.jpg');
INSERT INTO Item VALUES('Papaya Salad','Thai Delight',7.49,'Shredded green papaya salad','Salad','papaya_salad.jpg');
INSERT INTO Item VALUES('Red Curry Tofu','Thai Delight',11.99,'Tofu in spicy red curry','Tofu','red_curry_tofu.jpg');

CREATE TABLE OrderC (
    Order_Nr INTEGER PRIMARY KEY,
    Order_time_column TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Restaurant_NAME TEXT,
    TOTAL_PRICE NUMERIC(5, 2),
    Customer_EMAIL TEXT,
    STATUS TEXT, -- Changed to TEXT for SQLite
    Customer_Notes TEXT,
    CONSTRAINT orders_FK FOREIGN KEY (Customer_EMAIL) REFERENCES Customer(EMAIL), --changed from CUSTOMER_EMAIL
    CONSTRAINT orders_FK_1 FOREIGN KEY (Restaurant_NAME) REFERENCES Restaurant(NAME)  ----changed from RESTAURANT_NAME
);

CREATE TABLE order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_number INTEGER,
    item_name TEXT,
    quantity INT GER, --what is GER?
    total_price NUMERIC(5, 2),
    CONSTRAINT order_items_FK1 FOREIGN KEY (order_number) REFERENCES OrderC(Order_Nr),
    CONSTRAINT order_items_FK2 FOREIGN KEY (item_name) REFERENCES Item(ITEM_NAME)
);

-- Example trigger (you may need to adjust it based on your specific calculation logic)
CREATE TRIGGER calculate_total_price
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE OrderC
    SET TOTAL_PRICE = (
        SELECT SUM(total_price)
        FROM order_items
        WHERE order_number = NEW.order_number
    )
    WHERE Order_Nr = NEW.order_number;
END;
-- Order 1 for Anna Schmidt from Burger King
INSERT INTO OrderC (Order_time_column, Order_date, Restaurant_NAME, TOTAL_PRICE, Customer_EMAIL, STATUS)
VALUES ('2024-01-23 12:30:00', '2024-01-23', 'Burger King', 28.47, 'anna@gmail.com', 'Completed');

INSERT INTO order_items (order_number, item_name, quantity, total_price)
VALUES (1, 'Whopper', 1, 8.99),
       (1, 'Fries', 2, 5.98),
       (1, 'Chocolate Shake', 1, 4.99),
       (1, 'Grilled Chicken Salad', 1, 5.99),
       (1, 'Vanilla Soft Serve', 1, 1.99);

-- Order 2 for Anna Schmidt from Pizza Hut
INSERT INTO OrderC (Order_time_column, Order_date, Restaurant_NAME, TOTAL_PRICE, Customer_EMAIL, STATUS)
VALUES ('2024-01-22 18:45:00', '2024-01-22', 'Pizza Hut', 43.95, 'anna@gmail.com', 'Completed');

INSERT INTO order_items (order_number, item_name, quantity, total_price)
VALUES (2, 'Pepperoni Pizza', 2, 21.98),
       (2, 'Garlic Bread', 1, 4.99),
       (2, 'Tiramisu Hut', 1, 5.99),
       (2, 'Buffalo Wings', 1, 7.49),
       (2, 'Italian Gelato', 1, 4.50);

-- Order 1 for Max Muller from Sushi Express
INSERT INTO OrderC (Order_time_column, Order_date, Restaurant_NAME, TOTAL_PRICE, Customer_EMAIL, STATUS)
VALUES ('2024-01-23 20:15:00', '2024-01-23', 'Sushi Express', 58.95, 'max@gmail.com', 'Completed');

INSERT INTO order_items (order_number, item_name, quantity, total_price)
VALUES (3, 'Sushi Combo A', 1, 12.99),
       (3, 'Sashimi Platter', 1, 14.49),
       (3, 'Tempura Udon', 1, 10.99),
       (3, 'Edamame', 1, 3.99),
       (3, 'Miso Soup', 1, 2.49),
       (3, 'Dragon Roll', 1, 15.99),
       (3, 'Green Tea Ice Cream', 1, 4.99),
       (3, 'Rainbow Roll', 1, 13.49);

-- Order 2 for Max Muller from Steakhouse Deluxe
INSERT INTO OrderC (Order_time_column, Order_date, Restaurant_NAME, TOTAL_PRICE, Customer_EMAIL, STATUS)
VALUES ('2024-01-22 19:30:00', '2024-01-22', 'Steakhouse Deluxe', 89.46, 'max@gmail.com', 'Completed');

INSERT INTO order_items (order_number, item_name, quantity, total_price)
VALUES (4, 'T-Bone Steak', 1, 25.99),
       (4, 'Filet Mignon', 1, 29.99),
       (4, 'BBQ Ribs', 1, 18.99),
       (4, 'Cheeseburger', 1, 14.49);

-- Order 1 for Sophie Becker from Cafe Paris
INSERT INTO OrderC (Order_time_column, Order_date, Restaurant_NAME, TOTAL_PRICE, Customer_EMAIL, STATUS)
VALUES ('2024-01-23 08:45:00', '2024-01-23', 'Cafe Paris', 22.46, 'sophie@gmail.com', 'Completed');

INSERT INTO order_items (order_number, item_name, quantity, total_price)
VALUES (5, 'Croissant', 2, 5.98),
       (5, 'Quiche Lorraine', 1, 7.99),
       (5, 'Cafe au Lait', 1, 3.49),
       (5, 'French Onion Soup', 1, 5.99);

-- Order 2 for Sophie Becker from Pasta Palace
INSERT INTO OrderC (Order_time_column, Order_date, Restaurant_NAME, TOTAL_PRICE, Customer_EMAIL, STATUS)
VALUES ('2024-01-22 12:00:00', '2024-01-22', 'Pasta Palace', 41.46, 'sophie@gmail.com', 'Completed');

INSERT INTO order_items (order_number, item_name, quantity, total_price)
VALUES (6, 'Spaghetti Bolognese', 1, 11.99),
       (6, 'Fettuccine Alfredo', 1, 10.99),
       (6, 'Lasagna', 1, 12.99),
       (6, 'Garlic Breadsticks', 1, 4.99),
       (6, 'Caprese Salad', 1, 8.49);

-- Order 1 for Lukas Fischer from Vegetarian Haven
INSERT INTO OrderC (Order_time_column, Order_date, Restaurant_NAME, TOTAL_PRICE, Customer_EMAIL, STATUS)
VALUES ('2024-01-23 15:20:00', '2024-01-23', 'Vegetarian Haven', 32.94, 'lukas@gmail.com', 'Completed');

INSERT INTO order_items (order_number, item_name, quantity, total_price)
VALUES (7, 'Vegetarian Burger', 1, 9.99),
       (7, 'Mushroom Risotto', 1, 12.49),
       (7, 'Vegan Pizza', 1, 11.99),
       (7, 'Sweet Potato Fries', 1, 5.99),
       (7, 'Quinoa Salad', 1, 8.99);

-- Order 2 for Lukas Fischer from Mexican Fiesta
INSERT INTO OrderC (Order_time_column, Order_date, Restaurant_NAME, TOTAL_PRICE, Customer_EMAIL, STATUS)
VALUES ('2024-01-22 16:30:00', '2024-01-22', 'Mexican Fiesta', 37.46, 'lukas@gmail.com', 'Completed');

INSERT INTO order_items (order_number, item_name, quantity, total_price)
VALUES (8, 'Tacos Al Pastor', 2, 21.98),
       (8, 'Burrito Bowl', 1, 12.49),
       (8, 'Quesadilla', 1, 8.99),
       (8, 'Guacamole and Chips', 1, 6.99);

-- Order 1 for Emma Weber from Indian Spice
INSERT INTO OrderC (Order_time_column, Order_date, Restaurant_NAME, TOTAL_PRICE, Customer_EMAIL, STATUS)
VALUES ('2024-01-23 13:45:00', '2024-01-23', 'Indian Spice', 51.46, 'emma@gmail.com', 'Completed');

INSERT INTO order_items (order_number, item_name, quantity, total_price)
VALUES (9, 'Chicken Tikka Masala', 1, 13.99),
       (9, 'Vegetable Biryani', 1, 11.49),
       (9, 'Paneer Butter Masala', 1, 12.99),
       (9, 'Garlic Naan', 2, 7.98),
       (9, 'Aloo Gobi', 1, 9.99);

-- Order 2 for Emma Weber from Thai Delight
INSERT INTO OrderC (Order_time_column, Order_date, Restaurant_NAME, TOTAL_PRICE, Customer_EMAIL, STATUS)
VALUES ('2024-01-22 20:45:00', '2024-01-22', 'Thai Delight', 39.93, 'emma@gmail.com', 'Completed');

INSERT INTO order_items (order_number, item_name, quantity, total_price)
VALUES (10, 'Pad Thai', 1, 12.99),
       (10, 'Green Curry Chicken', 1, 13.49),
       (10, 'Tom Yum Soup', 1, 6.99),
       (10, 'Mango Sticky Rice', 1, 5.99);

-- Similar data for other customers and restaurants...


DELETE FROM sqlite_sequence; --?
COMMIT;
