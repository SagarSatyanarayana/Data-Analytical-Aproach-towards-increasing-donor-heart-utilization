library(nnet)
data_95 = read.csv("tx_95.csv", header=TRUE)
data_15 = read.csv("tx_15.csv", header=TRUE)
names(data_15)
reg_model_95 = glm(tx~age_don+bmi+lv_eject_don+tbili_don+creat_don+diabetes+liver_tx+sex+cocaine_hx+medical_hx+stroke+annoxia+trauma+cpr+inotropic_agents, data=data_95, family=binomial)
summary(reg_model_95)
reg_model_15 = glm(tx~age_don+bmi+lv_eject_don+tbili_don+creat_don+diabetes+liver_tx+sex+cocaine_hx+medical_hx+stroke+annoxia+trauma+cpr+inotropic_agents, data=data_15, family=binomial)
summary(reg_model_15)

predict_95 = predict(reg_model_95, newdata = data_15, type="response")
predict_95[1:20]


glm.pred_95=rep("N",nrow(data_15))
glm.pred_95[predict_95>0.5]="Y"

table(glm.pred_95,data_15$tx)

odds<-exp(coef(reg_model_15))


confint(reg_model_15)
exp(cbind("Odds ratio" = coef(reg_model_15), confint.default(reg_model_15, level = 0.95)))
coef(reg_model_15)


confint(reg_model_95)
exp(cbind("Odds ratio" = coef(reg_model_95), confint.default(reg_model_95, level = 0.95)))
coef(reg_model_95)