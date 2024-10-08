﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.АвторДокумента) Тогда
		Объект.АвторДокумента = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УслугиНоменклатураПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
		СтрокаТЧ.Цена = РаботаСЦенами.ПолучитьЦенуЗакупкиНаДату(СтрокаТЧ.Номенклатура, Объект.Поставщик, Объект.Дата);
	Иначе
		СтрокаТЧ.Цена = 0;
	КонецЕсли;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
	ПерерассчетСуммы();
КонецПроцедуры

&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)
	ПерерассчетСуммы();
КонецПроцедуры

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	ПерерассчетСуммы();
КонецПроцедуры

&НаКлиенте
Процедура ПерерассчетСуммы()
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
	Объект.СуммаДокумента = Объект.Услуги.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЦены(Команда)
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	Для Каждого СтрокаТЧ ИЗ Объект.Услуги Цикл
		Если ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
			СтрокаТЧ.Цена = РаботаСЦенами.ПолучитьЦенуЗакупкиНаДату(СтрокаТЧ.Номенклатура, Объект.Поставщик, Объект.Дата);
		Иначе
			СтрокаТЧ.Цена = 0;
		КонецЕсли;
		РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
		ПерерассчетСуммы();
	КонецЦикла;
КонецПроцедуры
