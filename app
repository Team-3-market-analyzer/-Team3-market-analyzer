import streamlit as st
import hashlib

# Function to securely hash passwords
def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

# Initialize session state variables for login status, username, and user data
if 'logged_in' not in st.session_state:
    st.session_state['logged_in'] = False
if 'username' not in st.session_state:
    st.session_state['username'] = None
if 'user_data' not in st.session_state:
    st.session_state['user_data'] = {}  # Use session state for user data

# Function to handle user registration
def register():
    st.subheader("Register")
    username = st.text_input("Username", key="register_username")
    email = st.text_input("Email", key="register_email")
    password = st.text_input("Password", type="password", key="register_password")
    confirm_password = st.text_input("Confirm Password", type="password", key="registration_confirm_password")

    if st.button("Register"):
        # Check if all fields are filled and passwords match
        if not username or not email or not password:
            st.warning("Please fill in all the fields.")
        elif username in st.session_state['user_data']:
            st.warning("Username already exists!")
        elif password != confirm_password:
            st.warning("Passwords do not match!")
        else:
            # Save the new user's details in session state
            st.session_state['user_data'][username] = {
                "email": email,
                "password": hash_password(password),
            }
            st.success("Registration successful! You can now log in.")

# Function to handle user login
def login():
    st.subheader("Login")
    username = st.text_input("Username", key="login_username")
    password = st.text_input("Password", type="password", key="login_password")

    if st.button("Login"):
        hashed_password = hash_password(password)
        # Check if the username and hashed password match the stored data
        user_data = st.session_state['user_data']
        if username in user_data and user_data[username]["password"] == hashed_password:
            st.session_state['logged_in'] = True
            st.session_state['username'] = username
            st.success(f"Welcome, {username}")
        else:
            st.error("Invalid username or password")

# Function to handle user logout
def logout():
    st.session_state['logged_in'] = False
    st.session_state['username'] = None
    st.info("You have logged out.")

# Function to display user details
def user_details():
    username = st.session_state['username']
    user_data = st.session_state['user_data']
    if username and username in user_data:
        st.subheader("User Details")
        st.write(f"Username: {username}")
        st.write(f"Email: {user_data[username]['email']}")

# Main function to handle the app's logic
def main():
    st.title("User Authentication with Streamlit")

    # Navigation logic based on whether the user is logged in or not
    if not st.session_state['logged_in']:
        # Show the registration or login option in the sidebar
        st.sidebar.title("Menu")

        # Display the current page for navigation (Register or Login)
        option = st.sidebar.radio("Choose an option:", ("Register", "Login"))

        # Conditional rendering based on the selected option
        if option == "Register":
            register()
        elif option == "Login":
            login()
    else:
        # Show the user details and logout option if logged in
        st.success(f"Logged in as {st.session_state['username']}")
        user_details()
        if st.button("Logout"):
            logout()

if __name__ == "__main__":
    main()

# For the execution of whole code giev the following command
""""
1)python --version
2)python -m venv env
env\Scripts\activate  
3) pip install streamlit pandas requests 
4) streamlit run app.py  
(Optional :- 5) Local URL: http://localhost:8501
Network URL: http://<your-network-ip>:8501)
"""""
