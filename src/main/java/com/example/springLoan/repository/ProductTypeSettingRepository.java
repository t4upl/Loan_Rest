package com.example.springLoan.repository;

import com.example.springLoan.model.ProductTypeSetting;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductTypeSettingRepository extends JpaRepository<ProductTypeSetting, Integer> {

    List<ProductTypeSetting> findByProductType_Id(Integer productTypeId);
}