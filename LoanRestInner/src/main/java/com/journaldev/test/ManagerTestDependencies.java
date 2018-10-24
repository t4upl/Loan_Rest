package com.journaldev.test;

import com.journaldev.dao.*;
import com.journaldev.entity.Product;
import com.journaldev.manager.ProductManager;
import com.journaldev.manager.ProductSettingManager;
import com.journaldev.other.EntityFactory;
import lombok.Getter;
import org.springframework.beans.factory.annotation.Autowired;

@Getter
public class ManagerTestDependencies {

    @Autowired
    private ProductSettingManager productSettingManager;

    @Autowired
    private ProductManager productManager;

    @Autowired
    private EntityFactory entityFactory;

    @Autowired
    private CustomerDAO customerDAO;

    @Autowired
    private ProductDAO productDAO;

    @Autowired
    private ProductTypeSettingDAO productTypeSettingDAO;

    @Autowired
    private ProductSettingDAO productSettingDAO;

    @Autowired
    private SettingTypeDAO settingTypeDAO;
}
