module SessionsHelper

    #logs in the given user
    def log_in(user)
        session[:user_id] = user.id
    end

    # Remembers a user in a presistent session
    def remember(user)
        user.remember
        # cookies[:user_id] = { value: user.id,
        #                       expires: 20.years.from_now.utc }
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    # Returns the current logged in user (if any)
    def current_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    # Checks if the user is logged in
    def logged_in?
        !current_user.nil?
    end

    # Forget a presistent session
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    # Logs out the current user
    def log_out
        forget(current_user)
        session.delete(:user_id)
        # session[:user_id] = nil
        @current_user = nil
    end

    # Returns true if the given user is the current user.
    def current_user?(user)
        user == current_user
    end
end
