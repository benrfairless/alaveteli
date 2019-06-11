# -*- encoding : utf-8 -*-
class AddCensorRuleRegexp < !rails5? ? ActiveRecord::Migration : ActiveRecord::Migration[4.2] # 2.3
  def self.up
    add_column :censor_rules, :regexp, :boolean
  end

  def self.down
    remove_column :censor_rules, :regexp
  end
end