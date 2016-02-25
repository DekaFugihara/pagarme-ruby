module PagarMe
  class Subscription < TransactionCommon
    def create
      set_plan_id
      super
    end

    def save
      set_plan_id
      super
    end

    def cancel
      update PagarMe::Request.post(url 'cancel').run
    end

    def charge(amount, installments = 1)
      PagarMe::Request.post(url('transactions'), params: {
        amount:       amount,
        installments: installments
      }).run

      update PagarMe::Request.get(url).run
    end

    protected
    def set_plan_id
      if plan
        self.plan_id = plan.id
        self.plan    = nil
      end
    end
  end
end
