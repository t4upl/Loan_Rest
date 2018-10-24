package com.journaldev.other;

import com.journaldev.entity.*;

public interface EntityFactory {
    Customer getCustomer (int id, String name);
    Product getProduct (int id, int productTypeId, int customerId);
    ProductTypeSetting getProductTypeSetting(Integer id, Integer productTypeId, Integer settingTypeId, String value);
    ProductSetting getProductSetting(int id, int productId, int setttingTypeId, String value) ;
    SettingType getSettingType(int id, String name);
}
