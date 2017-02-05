require 'users_helper'

class User < ActiveRecord::Base
  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id'
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  validates :email, presence: true, uniqueness: true, format: {
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
    message: 'Invalid email format.'
  }
  validates :referral_code, uniqueness: true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 2,
      'html' => 'EAOS<br>STICKER',
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        'assets/biker/EAOS_Sticker_2.jpg')
    },
    {
      'count' => 5,
      'html' => 'TAKE FLIGHT<br>KEY CHAIN',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path('assets/biker/KeyChain.jpg')
    },
    {
      'count' => 20,
      'html' => 'MOTORCYCLE<br>PHONE HOLDER',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path('assets/biker/phone_holder_20.jpg')
    },
    {
      'count' => 40,
      'html' => 'VIP<br>LOUNGE',
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/biker/VIP_40.jpg')
    }
  ]

  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def send_welcome_email
    UserMailer.delay.signup_email(self)
  end
end
