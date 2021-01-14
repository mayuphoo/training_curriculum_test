class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
  

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    
    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6) 
    # 今日〜6日後までのデータ。

    7.times do |x|
      today_plans = [] #空の配列を用意
      plans.each do |plan| #今日〜6日後までのデータを、planとして1つずつ取り出す。
        today_plans.push(plan.plan) if plan.date == @todays_date + x #1日分の予定を、todays_plan配列に追加する。もし日付が7日後までの間だったら。
      end

    wday_num = Date.today.wday + x
      if wday_num >= 7
        wday_num = wday_num -7
        # 7以上の数字になったら−７して0に戻す。
      end

      days = { month: (@todays_date + x).month, date: @todays_date.day + x, plans: today_plans, wday: wdays[wday_num] }
      @week_days.push(days)
    end

  end
end