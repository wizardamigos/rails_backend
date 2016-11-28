class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
  end

  def new
  end

  def last_lesson
    id = params["id"]
    last_lesson = params["last_lesson"]
    user = User.find_by_github_id(id)
    if last_lesson
      response = update_last_lesson(last_lesson, user)
    else
      response = user.last_lesson
    end
    render json: response
  end

  def update_last_lesson(last_lesson, user)
    user.update(last_lesson: last_lesson)
    response = "Last lesson is updated"
  end

end
