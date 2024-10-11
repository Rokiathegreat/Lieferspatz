import re

# Helper function to validate restaurant registration form data
def validate_restaurant_registration(form):
    # Basic required fields check
    required_fields = ['name', 'email', 'address', 'zip_code', 'password', 'description', 'opening_time', 'closing_time', 'zip_codes', 'photo']
    for field in required_fields:
        if field not in form or not form[field].strip():
            return False
    
    # Check for valid email format using regex (simplified version)
    if not re.match(r"[^@]+@[^@]+\.[^@]+", form['email']):
        return False

    # Ensure password is of a certain length (e.g., at least 6 characters)
    if len(form['password']) < 6:
        return False
    
    # Check if zip code is numeric and of a valid length (assuming 5 digits for this example)
    if not form['zip_code'].isdigit() or len(form['zip_code']) != 5:
        return False
    
    # Check opening and closing times format (assuming HH:MM format for this example)
    time_pattern = r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$'
    if not re.match(time_pattern, form['opening_time']) or not re.match(time_pattern, form['closing_time']):
        return False

    # You could add a check for the photo to ensure it's a valid file type or URL
    # For example, check if the photo field contains URL of an image

    # Ensure the zip_codes field is a list of zip codes separated by commas
    # Here we just check if it's a non-empty string, you could split and validate each zip code individually
    if not form['zip_codes'].strip():
        return False

    # Additional checks for other fields can be added here
    
    return True  # Passes all checks