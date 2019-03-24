package com.example.springLoan.service;

import com.example.springLoan.dto.ProductRequestDTO;
import com.example.springLoan.factory.AbstractFactory;
import com.example.springLoan.model.ProductSetting;
import com.example.springLoan.model.ProductTypeSetting;
import com.example.springLoan.repository.ProductSettingRepository;
import com.example.springLoan.util.FilterUtil;
import com.example.springLoan.util.constant.EntityUtil;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class ProductSettingServiceImpl implements ProductSettingService {

    ProductSettingRepository productSettingRepository;
    ProductTypeSettingService productTypeSettingService;
    AbstractFactory abstractFactory;

    @Override
    public Set<ProductSetting> getProductSettings(ProductRequestDTO productRequestDTO) {
        List<ProductTypeSetting> productTypeSettings = productTypeSettingService.findByProductType_Id(
                productRequestDTO.getProductTypeId());

        return productTypeSettings
                .stream()
                .map(pts -> mapProductTypeSettingToProductSetting(pts, productRequestDTO, productTypeSettings))
                .collect(Collectors.toSet());
    }

    @Override
    public Set<ProductSetting> addTermToDueDate(Set<ProductSetting> productSettingSet) {
        ProductSetting termProductSetting = findProductSettingBySettingName(productSettingSet, EntityUtil.Setting.TERM);
        ProductSetting dueDateProductSetting = findProductSettingBySettingName(productSettingSet,
                EntityUtil.Setting.DUE_DATE);
        LocalDateTime dueDate = (LocalDateTime) FilterUtil.convertStringToJava(dueDateProductSetting.getValue(),
                EntityUtil.DataType.LOCAL_DATE_TIME);

        Integer term = (Integer) FilterUtil.convertStringToJava(termProductSetting.getValue(),
                EntityUtil.DataType.INTEGER);

        dueDateProductSetting.setValue(FilterUtil.convertJavaToString(dueDate.plusDays(term),
                EntityUtil.DataType.LOCAL_DATE_TIME));
        return productSettingSet;
    }

    private ProductSetting findProductSettingBySettingName(Set<ProductSetting> productSettingSet, String name){
        return productSettingSet.stream()
                .filter(x -> name.equals(x.getSetting().getName()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException(String.format("findProductSettingBySettingName exception: " +
                        "no ProductSetting with name: %s", name)));
    }


    private ProductSetting mapProductTypeSettingToProductSetting(ProductTypeSetting productTypeSetting,
                                                                 ProductRequestDTO productRequestDTO,
                                                                 List<ProductTypeSetting> productTypeSettings) {
        if (!productTypeSetting.getSetting().getIsRuntimeInput()) {
            return getProductSetting(productTypeSetting, productTypeSetting.getValue());
        }

        return getProductSetting(productTypeSetting,
                getValueForProductSetting(productTypeSetting, productRequestDTO, productTypeSettings));
    }

    private ProductSetting getProductSetting(ProductTypeSetting productTypeSetting, String value) {
        return abstractFactory.getProductSettingFactory()
                .getProductSetting(null, value, null, productTypeSetting.getSetting());
    }

    private String getValueForProductSetting(ProductTypeSetting productTypeSetting,
                                             ProductRequestDTO productRequestDTO,
                                             List<ProductTypeSetting> productTypeSettings) {

        String dataTypeName = productTypeSetting.getSetting().getDataType().getName();
        Optional<Object> javaObjectOpt = Optional.empty();

        switch (productTypeSetting.getSetting().getName()) {
            case (EntityUtil.Setting.APPLICATION_DATE):
                javaObjectOpt = Optional.of(productRequestDTO.getApplicationDate());
                break;
            case (EntityUtil.Setting.AMOUNT):
                javaObjectOpt = Optional.of(productRequestDTO.getAmount());
                break;
            case (EntityUtil.Setting.DUE_DATE):
                javaObjectOpt = Optional.of(productRequestDTO.getApplicationDate().plusDays(
                        productRequestDTO.getTerm()));
                break;
            case (EntityUtil.Setting.AMOUNT_TO_PAY):
                double rateOfIntrest = productTypeSettingService.findAndGetAsDouble(productTypeSettings,
                        EntityUtil.Setting.RATE_OF_INTEREST);
                javaObjectOpt = Optional.of(Double.valueOf(productRequestDTO.getAmount())
                        * (1 + rateOfIntrest / 100));
                break;
            case (EntityUtil.Setting.TERM):
                javaObjectOpt = Optional.of(productRequestDTO.getTerm());
                break;
        }

        if (javaObjectOpt.isPresent()) {
            return FilterUtil.convertJavaToString(javaObjectOpt.get(), dataTypeName);
        }
        throw new RuntimeException(String.format("getValueForProductSetting - case not found for Setting with name %s",
                productTypeSetting.getSetting().getName()));
    }
}
