﻿&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	Если Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизаций.ЮридическоеЛицо") Тогда
		Элементы.ГлавныйБухгалтер.Видимость = Истина;
	Иначе
		Элементы.ГлавныйБухгалтер.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТипОрганизацииПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры
