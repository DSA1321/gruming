﻿Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ДенежныеСредства.Записывать = Истина;
	Движение = Движения.ДенежныеСредства.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.ТипДенежныхСредств = Перечисления.ТипыДенежныхСредств.Безналичные;
	Движение.БанковскийСчетКасса = РасчетныйСчет;
	Движение.Сумма = СуммаДокумента;
	АналитикаПроводки = ПолучитьАналитикуПроводки();	
	Движения.Хозрасчетный.Записывать = Истина;    
	Если ВидОперации = Перечисления.ВидыОперацийПоступленияНаРасчетныйСчет.ВзносНаличными Тогда
		Возврат; 
	КонецЕсли;
	Движение = Движения.Хозрасчетный.Добавить();
	Движение.СчетДт = АналитикаПроводки.СчетДебета;
	Движение.СчетКт = АналитикаПроводки.СчетКредита;
	Движение.Период = Дата;
	Движение.Сумма = СуммаДокумента;
	Движение.Содержание = АналитикаПроводки.СодержаниеОперации;
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетДт, Движение.СубконтоДт, АналитикаПроводки.СубконтоДебет);
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетКт, Движение.СубконтоКт, АналитикаПроводки.СубконтоКредит);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровИУслуг") Тогда
		ВидОперации = Перечисления.ВидыОперацийПоступленияНаРасчетныйСчет.ОплатаОтПокупателя;
		Плательщик = ДанныеЗаполнения.Клиент;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступленияТоваровИМатериалов") Тогда 
		ВидОперации = Перечисления.ВидыОперацийПоступленияНаРасчетныйСчет.ВозвратОтПоставщика;
		Плательщик = ДанныеЗаполнения.Поставщик;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеУслуг") Тогда
		ВидОперации = Перечисления.ВидыОперацийПоступленияНаРасчетныйСчет.ВозвратОтПоставщика;
		Плательщик = ДанныеЗаполнения.Поставщик;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Не ЗначениеЗаполнено(АвторДокумента) Тогда
		АвторДокумента = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьАналитикуПроводки()
	ОплатаОтПокупателя = Перечисления.ВидыОперацийПоступленияНаРасчетныйСчет.ОплатаОтПокупателя;
	ВозвратОтПоставщика = Перечисления.ВидыОперацийПоступленияНаРасчетныйСчет.ВозвратОтПоставщика;
	ОплатаПоБанковскимКартам = Перечисления.ВидыОперацийПоступленияНаРасчетныйСчет.ОплатаПоБанковскимКартам;
	ПоступлениеСДругогоСчетаПредприятия = Перечисления.ВидыОперацийПоступленияНаРасчетныйСчет.ПоступлениеСДругогоСчетаПредприятия;
	СтруктураАналитики = Новый Структура;
	СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.РасчетныеСчета);
	СтруктураАналитики.Вставить("СубконтоДебет", РасчетныйСчет);
	Если ВидОперации = ОплатаОтПокупателя Тогда
		СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.РасчетыСПокупателями);
		СтруктураАналитики.Вставить("СубконтоКредит", Плательщик);
		СтруктураАналитики.Вставить("СодержаниеОперации", "Оплата от покупателя на расчетный счет");
	ИначеЕсли ВидОперации = ВозвратОтПоставщика Тогда
		СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками);    
		СтруктураАналитики.Вставить("СубконтоКредит", Плательщик);
		СтруктураАналитики.Вставить("СодержаниеОперации", "Возврат средств поставщику с расчетного счета");
	ИначеЕсли ВидОперации = ОплатаПоБанковскимКартам Тогда 
		СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.ПереводыВПути);
		СтруктураАналитики.Вставить("СубконтоКредит", ЭквайринговыйТерминал);
		СтруктураАналитики.Вставить("СодержаниеОперации", "Поступление на расчетный счет по операциям с банковскими картами");
	ИначеЕсли ВидОперации = ПоступлениеСДругогоСчетаПредприятия Тогда
			СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.РасчетныеСчета);
			СтруктураАналитики.Вставить("СубконтоКредит", ЭтотОбъект.РасчетныйСчетИсточник);
			СтруктураАналитики.Вставить("СодержаниеОперации", "Переводы между расчетными счетами организации");
	КонецЕсли;
	Возврат СтруктураАналитики;   
КонецФункции

Функция ПолучитьДанныеПоРеализацииТоваровИУслуг(ДанныеЗаполнения)
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);    
	Запрос.Текст=
	"ВЫБРАТЬ
	|    РеализацияТоваровИУслуг.Клиент КАК Плательщик,
	|    РеализацияТоваровИУслуг.СуммаДокумента КАК СуммаДокумента,
	|    РеализацияТоваровИУслуг.Ссылка КАК ДокументОснование,
	|    ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступленияНаРасчетныйСчет.ОплатаОтПокупателя) КАК ВидОперации
	|ИЗ
	|    Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
	|ГДЕ
	|    РеализацияТоваровИУслуг.Ссылка = &Ссылка";        
	Выборка =  Запрос.Выполнить().Выбрать();
	Выборка.Следующий();     
	Возврат Выборка;    
КонецФункции

Функция ПолучитьДанныеПоПоступлениюТоваровИМатериалов(ДанныеЗаполнения)
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	Запрос.Текст=
	"ВЫБРАТЬ
	|    ПоступлениеТоваровИМатериалов.Поставщик КАК Плательщик,
	|    ПоступлениеТоваровИМатериалов.ДоговорПоставщика КАК ДоговорКонтрагента,
	|    ПоступлениеТоваровИМатериалов.СуммаДокумента КАК СуммаДокумента,
	|    ПоступлениеТоваровИМатериалов.Ссылка КАК ДокументОснование,
	|    ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступленияНаРасчетныйСчет.ВозвратОтПоставщика) КАК ВидОперации
	|ИЗ
	|    Документ.ПоступлениеТоваровИМатериалов КАК ПоступлениеТоваровИМатериалов
	|ГДЕ
	|    ПоступлениеТоваровИМатериалов.Ссылка = &Ссылка";        
	Выборка =  Запрос.Выполнить().Выбрать();
	Выборка.Следующий();    
	Возврат Выборка;   
КонецФункции

Функция ПолучитьДанныеПоПоступлениюУслуг(ДанныеЗаполнения)
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	Запрос.Текст=
	"ВЫБРАТЬ
	|    ПоступлениеУслуг.Поставщик КАК Плательщик,
	|    ПоступлениеУслуг.ДоговорПоставщика КАК ДоговорКонтрагента,
	|    ПоступлениеУслуг.СуммаДокумента КАК СуммаДокумента,
	|    ПоступлениеУслуг.Ссылка КАК ДокументОснование,
	|    ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступленияНаРасчетныйСчет.ВозвратОтПоставщика) КАК ВидОперации
	|ИЗ
	|    Документ.ПоступлениеУслуг КАК ПоступлениеУслуг
	|ГДЕ
	|    ПоступлениеУслуг.Ссылка = &Ссылка";    
	Выборка =  Запрос.Выполнить().Выбрать();
	Выборка.Следующий();     
	Возврат Выборка;    
КонецФункции