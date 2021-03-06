install.packages("zoo")
library("zoo")

?decompose
require(graphics)
m <- decompose(co2)
m$figure
plot(m)

library(readxl)

setwd("C:/dev/r/Chapter 1")
aapl <- read.zoo("aapl.csv",sep=",", header = TRUE, format = "%Y-%m-%d")
aapl
plot(aapl, main ="APPLE")

head(aapl)
tail(aapl)
aapl[which.max(aapl)]
#?ด๊ฒ์ฒ?ผ ? ??ฑ?ด ?? ?๋ฃ๋ก? ??ต?จ? ๊ตฌํ๊ธ? ??ค?ค.
?diff
tail(aapl)
tail(lag(aapl,k=-1))
#??ต๋ฅ?
ret_simple <- diff(aapl) / lag(aapl,k=-1)*100
ret_cont <- diff(log(aapl))*100
plot(ret_simple)
tail(ret_simple)
tail(ret_cont)

?coredata
coredata(ret_simple)
summary(coredata(ret_simple))

ret_simple[which.min(ret_simple)]

hist(ret_simple,breaks = 100,xlab = "%")

aapl_2013 <- window(aapl,start = '2013-01-01',end = '2013-12-31')
aapl_2013[which.max(aapl_2013)]

#Value at Risk: ์ต๋? ??ค ๊ธ์ก
quantile(ret_simple,probs=0.01)
#??ต?จ?ด -7.04?ด?๋ก? ??ฌ ?๋ฅ ์ด 1%?ด?ค.

install.packages("forecast")
library("forecast")
hp <- read.zoo("UKHP.csv", sep=",", header=TRUE, format = "%Y-%m"
               ,FUN = as.yearmon)
hp_ret <- diff(hp)/lag(hp,k=-1)*100#??ต
mod <- auto.arima(hp_ret,stationary = TRUE,
                  seasonal = FALSE, ic="aic")
mod
#ar1, ar2, mean? ??? ๊ฐ์ ๋ณด์ฌ์ค?ค.
#๊ฐ? ๋ชจ๋ธ? ??? ๊ฐ์ค aic๊ฐ ๊ฐ?ฅ ?ฎ๊ฒ? ???ผ๋ฏ๋ก? ๊ฐ?ฅ ? ?ฉ??ค.
confint(mod)
par("mar")

par(mar=c(1,1,1,1))

tsdiag(mod)

plot(mod$x,lty=1,main="test")
lines(fitted(mod),lty=2,lwd=2,col="red")

accuracy(mod)

predict(mod,n.ahead = 3)
plot(forecast(mod))


install.packages("urca")
library("urca")
price <- read.zoo("JetFuelHedging.csv",sep=",",FUN=as.yearmon,
                  format = "%Y-%m",header = TRUE)
#์ต์ ?ด์ง๋น์จ
simple_mod <- lm(diff(price$JetFuel)~diff(price$HeatingOil)+0)
#?ฌ๊ธฐ์ +0?? ? ?ธ, ๊ทผ๋ฐ ? ~๋ฅ? ??? ๋น์จ?
summary(simple_mod)
plot(price$JetFuel, xlab = "Date",ylab = "USD")
lines(price$HeatingOil,col="red")

?ur.df
#?จ?๊ทผ๊?? 
#???ญ?? ?์ง๋ง? ์ถ์ธ๊ฐ ??...
plot(price$JetFuel)
jf_adf <- ur.df(price$JetFuel, type="drift")
summary(jf_adf)
ho_adf <- ur.df(price$HeatingOil,type="drift")
summary(ho_adf)
#๊ณต์ ๋ถ์ ?  ?, ? ๊ทธ๋?๊ฐ ?๋ฅ ์  ์ถ์ธ๋ฅ? ๊ฐ? ธ?ผ ??ค. ๊ทธ๋? 
#?จ?๊ทผ๊?? ? ??ค.

#? ??  ๊ท ํ ๋ชจ๋ธ ์ถ์  ๋ฐ? ?์ฐ? ? ??ฑ ๊ฒ? 
mod_static <- summary(lm(price$JetFuel~price$HeatingOil))
error <- residuals(mod_static)
error_cadf <- ur.df(error,type="none")#?์ฐจ์? ?ค? ?จ?๊ท? ๊ฒ? ? ?ด์ฃผ๋ฉด!
summary(error_cadf)#๊ฒฐ๊ณผ ??ธ
#???ฐ๊ฐ์ด? ๊ฒ? ?ต๊ณ๋ ๊ฐ์ ๋น๊ต?ด๋ณด๋ฉด ๊ฒ? ?ต๊ณ๋ ๊ฐ์ด ? ?๊ธ? ?๋ฌธ์
#๊ท๋ฌด๊??ค? ๊ธฐ๊ฐ??ค. ?ฐ?ผ? ?? ? ?ด?ค.


#?ค๋ฅ? ๊ต์  ๋ชจ๋ธ ??
dif <- diff(price$JetFuel)
dho <- diff(price$HeatingOil)
error_lag <- lag(error,k=-1)
mod_ecm <- lm(dif~dho+error_lag+0)
summary(mod_ecm)



#๋ณ??ฑ ๋ชจ๋ธ
intc <- read.zoo("intc.csv",header = TRUE,
                 sep = ",", format = "%Y-%m",FUN = as.yearmon)
plot(intc)

#Grarch
install.packages("rugarch")
library("rugarch")
intc_garch11_spec <- ugarchspec
(variance.model = list(
  garchOrder =c(1,1)),
  mean.model = list(armaOrder=c(0,0)))
intc_garch11_spec
intc_garch11_fit <- ugarchfit(spec = intc_garch11_spec,data=intc)
intc_garch11_fit
