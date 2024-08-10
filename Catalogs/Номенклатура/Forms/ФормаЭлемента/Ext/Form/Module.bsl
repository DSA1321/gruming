﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ Объект.Ссылка.Пустая() Тогда
		ТекущаяРозничнаяЦена = РаботаСЦенами.ПолучитьЦенуПродажиНаДату(Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЦену(Команда)
	Если Объект.Ссылка.Пустая() Тогда //1
		Сообщить("Перед установкой цены необходимо записать документ!");
	Иначе
		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаСозданияЦены",Новый Структура("Номенклатура", Объект.Ссылка),,,,,
		Новый ОписаниеОповещения("ПослеИзмененияЦены", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеИзмененияЦены(Результат, ДополнительныеПараметры) Экспорт
	ТекущаяРозничнаяЦена =  РаботаСЦенами.ПолучитьЦенуПродажиНаДату(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ТипНоменклатурыПриИзменении(Элемент)
	Если Объект.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатур.Материал") Тогда
		Объект.СчетБухгалтерскогоУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.Материалы");
	ИначеЕсли Объект.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатур.Товар") Тогда
		Объект.СчетБухгалтерскогоУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.Товары");
	ИначеЕсли Объект.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатур.Услуга") Тогда
		Объект.СчетБухгалтерскогоУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.РасходыНаПродажу");
	КонецЕсли;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	Если Объект.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатур.Услуга") Тогда
		Элементы.ДлительностьУслуги.Видимость = Истина;
	Иначе
		Элементы.ДлительностьУслуги.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СчетБухгалтерскогоУчетаНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;       
	СписокДоступныхЗначений = Новый СписокЗначений;    
	Если Объект.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатур.Товар") Тогда
		СписокДоступныхЗначений.Добавить(ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.Товары"));
	ИначеЕсли Объект.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатур.Материал") Тогда
		СписокДоступныхЗначений.Добавить(ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.Материалы"))
	ИначеЕсли  Объект.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатур.Услуга") Тогда
		СписокДоступныхЗначений.Добавить(ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.РасходыНаПродажу"));
		СписокДоступныхЗначений.Добавить(ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ПрочиеДоходыИРасходы"));
	Иначе
		СписокДоступныхЗначений.Добавить(ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ПустаяСсылка"));
	КонецЕсли;    
	ДанныеВыбора = СписокДоступныхЗначений;
КонецПроцедуры

