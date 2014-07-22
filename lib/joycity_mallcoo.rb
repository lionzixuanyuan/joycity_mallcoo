require "joycity_mallcoo/version"
require 'unirest'
require 'digest/md5'

module JoycityMallcoo
  # Your code goes here...
  class Info
    # test url
    URL = 'http://test.openapi.mallcoo.cn/rongyi/'

    def initialize appkey, secret, mall_id
      @appkey, @secret, @mall_id = appkey, secret, mall_id
    end

    def get_sig params_str
      Digest::MD5.hexdigest("#{params_str}&#{@secret}").upcase
    end

    def request action, params={}
      params_arr = []
      params.merge!(appkey: @appkey, ts: Time.now.to_i, mallID: @mall_id)
      params.each_pair{|k, v| params_arr << "#{k}=#{v}" }
      params_str = params_arr.sort.join("&")
      sig = get_sig params_str

      JSON.parse(Unirest.get("#{URL}#{action}/?#{params_str}&sig=#{sig}").raw_body)
    end

    # 获取容易网首页信息
    def get_index_info
      request "GETIndexInfo"
    end

    # 获取获取商场活动
    def get_activities
      request "GetActivities"
    end

    # 按商户ID返回商户详细信息
    def get_brand_by_id brand_id
      request "GetBrandById", brandID: brand_id
    end

    # 按商户类型ID返回商户
    def get_brand_by_type_id brand_type_id
      request "GetBrandByTypeID", brandTypeID: brand_type_id
    end

    # 根据拼音首字母搜索
    def get_brand_by_type_letter letter
      request "GetBrandByTypeLetter", letter: letter
    end

    # 获取有优惠的品牌优惠信
    def get_brand_have_preferential
      request "GetBrandHavePreferential"
    end

    # 获取品牌类型
    def get_brand_type
      request "GetBrandType"
    end

    # 查询会员积分记录
    def get_member_bonus_record card_no, page, page_size
      request "GetMemberBonusLedgerRowCount", cardNo: card_no, pageIndex: page, pageSize: page_size
    end

    # 获取礼品列表
    def get_all_gift
      request "GetAllGift"
    end

    # 用户能兑换的礼品
    def get_gift_by_user card_no
      request "GetGiftbyUser", cardNo: card_no
    end

    # 兑换礼品
    def points_exchange_gift card_no, gift_id
      request "PointsExchangeGift", cardNo: card_no, giftId: gift_id
    end

  end
end
