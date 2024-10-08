﻿Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Движения.ТоварыНаСкладах.Записать();
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ТоварыНаСкладах");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = Товары;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
	ЭлементБлокировки.УстановитьЗначение("Склад", СкладОтправитель);
	ЭлементБлокировки.УстановитьЗначение("Склад", СкладПолучатель);
	Блокировка.Заблокировать();
	Если Константы.ПеремещениеТоваровСИстекающимСрокомГодности.Получить() Тогда
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПеремещениеТоваров.СкладОтправитель КАК СкладОтправитель,
		|	ПеремещениеТоваровТовары.Номенклатура КАК Номенклатура,
		|	СУММА(ПеремещениеТоваровТовары.Количество) КАК Количество
		|ПОМЕСТИТЬ ВТ_Товары
		|ИЗ
		|	Документ.ПеремещениеТоваров.Товары КАК ПеремещениеТоваровТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
		|		ПО ПеремещениеТоваровТовары.Ссылка = ПеремещениеТоваров.Ссылка
		|ГДЕ
		|	ПеремещениеТоваровТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПеремещениеТоваров.СкладОтправитель,
		|	ПеремещениеТоваровТовары.Номенклатура
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	СкладОтправитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Товары.Номенклатура КАК Номенклатура,
		|	ВТ_Товары.Номенклатура.Представление КАК НоменклатураПредставление,
		|	ВТ_Товары.СкладОтправитель КАК СкладОтправитель,
		|	ВТ_Товары.Количество КАК КоличествоВДокументе,
		|	ЕСТЬNULL(ТоварыНаСкладахОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
		|	ЕСТЬNULL(ТоварыНаСкладахОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
		|	ТоварыНаСкладахОстатки.СрокГодности КАК СрокГодности
		|ИЗ
		|	ВТ_Товары КАК ВТ_Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(
		|				,
		|				(Номенклатура, Склад) В
		|					(ВЫБРАТЬ
		|						ВТ_Товары.Номенклатура,
		|						ВТ_Товары.СкладОтправитель
		|					ИЗ
		|						ВТ_Товары КАК ВТ_Товары)) КАК ТоварыНаСкладахОстатки
		|		ПО ВТ_Товары.Номенклатура = ТоварыНаСкладахОстатки.Номенклатура
		|			И ВТ_Товары.СкладОтправитель = ТоварыНаСкладахОстатки.Склад
		|
		|УПОРЯДОЧИТЬ ПО
		|	СрокГодности
		|ИТОГИ
		|	МАКСИМУМ(КоличествоВДокументе),
		|	СУММА(КоличествоОстаток)
		|ПО
		|	Номенклатура";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		ВыборкаНоменклатура = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаНоменклатура.Следующий() Цикл
			СтоимостьОбщая = 0;
			Превышение = ВыборкаНоменклатура.КоличествоВДокументе - ВыборкаНоменклатура.КоличествоОстаток;
			Если Превышение > 0 Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтрШаблон("Превышение остатка по номенклатуре ""%1"" в количестве ""%2""", ВыборкаНоменклатура.НоменклатураПредставление, Превышение);
				Сообщение.Сообщить();
				Отказ = Истина;
			КонецЕсли;
			Если Отказ Тогда
				Продолжить;
			КонецЕсли;
			ОсталосьСписать = ВыборкаНоменклатура.КоличествоВДокументе;
			ВыборкаДетальные = ВыборкаНоменклатура.Выбрать();
			Пока ВыборкаДетальные.Следующий() И ОсталосьСписать > 0 Цикл
				Списываем = Мин(ВыборкаДетальные.КоличествоОстаток, ОсталосьСписать);
				Движение = Движения.ТоварыНаСкладах.ДобавитьРасход();
				Движение.Период = Дата;
				Движение.Номенклатура = ВыборкаДетальные.Номенклатура;
				Движение.Склад = ВыборкаДетальные.СкладОтправитель;
				Движение.СрокГодности = ВыборкаДетальные.СрокГодности;
				Движение.Количество = Списываем;
				Если Списываем = ВыборкаДетальные.КоличествоОстаток Тогда
					Движение.Сумма = ВыборкаДетальные.СуммаОстаток;
				Иначе
					Движение.Сумма = Списываем / ВыборкаДетальные.КоличествоОстаток * ВыборкаДетальные.СуммаОстаток;
				КонецЕсли;
				ОсталосьСписать = ОсталосьСписать - Списываем;
				
				Движение = Движения.ТоварыНаСкладах.ДобавитьПриход();
				Движение.Период = Дата;
				Движение.Номенклатура = ВыборкаНоменклатура.Номенклатура;
				Движение.Склад = СкладПолучатель;
				Движение.СрокГодности = ВыборкаДетальные.СрокГодности;
				Движение.Количество = Списываем;
				Если Списываем = ВыборкаДетальные.КоличествоОстаток Тогда
					Движение.Сумма = ВыборкаДетальные.СуммаОстаток;
				Иначе
					Движение.Сумма = Списываем / ВыборкаДетальные.КоличествоОстаток * ВыборкаДетальные.СуммаОстаток;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Иначе
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПеремещениеТоваров.СкладОтправитель КАК СкладОтправитель,
		|	ПеремещениеТоваровТовары.Номенклатура КАК Номенклатура,
		|	СУММА(ПеремещениеТоваровТовары.Количество) КАК Количество
		|ПОМЕСТИТЬ ВТ_Товары
		|ИЗ
		|	Документ.ПеремещениеТоваров.Товары КАК ПеремещениеТоваровТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
		|		ПО ПеремещениеТоваровТовары.Ссылка = ПеремещениеТоваров.Ссылка
		|ГДЕ
		|	ПеремещениеТоваровТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПеремещениеТоваров.СкладОтправитель,
		|	ПеремещениеТоваровТовары.Номенклатура
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	СкладОтправитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Товары.Номенклатура КАК Номенклатура,
		|	ВТ_Товары.Номенклатура.Представление КАК НоменклатураПредставление,
		|	ВТ_Товары.СкладОтправитель КАК СкладОтправитель,
		|	ВТ_Товары.Количество КАК КоличествоВДокументе,
		|	ЕСТЬNULL(ТоварыНаСкладахОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
		|	ЕСТЬNULL(ТоварыНаСкладахОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
		|	ТоварыНаСкладахОстатки.СрокГодности КАК СрокГодности
		|ИЗ
		|	ВТ_Товары КАК ВТ_Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(
		|				,
		|				(Номенклатура, Склад) В
		|					(ВЫБРАТЬ
		|						ВТ_Товары.Номенклатура,
		|						ВТ_Товары.СкладОтправитель
		|					ИЗ
		|						ВТ_Товары КАК ВТ_Товары)) КАК ТоварыНаСкладахОстатки
		|		ПО ВТ_Товары.Номенклатура = ТоварыНаСкладахОстатки.Номенклатура
		|			И ВТ_Товары.СкладОтправитель = ТоварыНаСкладахОстатки.Склад
		|
		|УПОРЯДОЧИТЬ ПО
		|	СрокГодности УБЫВ
		|ИТОГИ
		|	МАКСИМУМ(КоличествоВДокументе),
		|	СУММА(КоличествоОстаток)
		|ПО
		|	Номенклатура";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		ВыборкаНоменклатура = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаНоменклатура.Следующий() Цикл
			СтоимостьОбщая = 0;
			Превышение = ВыборкаНоменклатура.КоличествоВДокументе - ВыборкаНоменклатура.КоличествоОстаток;
			Если Превышение > 0 Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтрШаблон("Превышение остатка по номенклатуре ""%1"" в количестве ""%2""", ВыборкаНоменклатура.НоменклатураПредставление, Превышение);
				Сообщение.Сообщить();
				Отказ = Истина;
			КонецЕсли;
			Если Отказ Тогда
				Продолжить;
			КонецЕсли;
			ОсталосьСписать = ВыборкаНоменклатура.КоличествоВДокументе;
			ВыборкаДетальные = ВыборкаНоменклатура.Выбрать();
			Пока ВыборкаДетальные.Следующий() И ОсталосьСписать > 0 Цикл
				Списываем = Мин(ВыборкаДетальные.КоличествоОстаток, ОсталосьСписать);
				Движение = Движения.ТоварыНаСкладах.ДобавитьРасход();
				Движение.Период = Дата;
				Движение.Номенклатура = ВыборкаДетальные.Номенклатура;
				Движение.Склад = ВыборкаДетальные.СкладОтправитель;
				Движение.СрокГодности = ВыборкаДетальные.СрокГодности;
				Движение.Количество = Списываем;
				Если Списываем = ВыборкаДетальные.КоличествоОстаток Тогда
					Движение.Сумма = ВыборкаДетальные.СуммаОстаток;
				Иначе
					Движение.Сумма = Списываем / ВыборкаДетальные.КоличествоОстаток * ВыборкаДетальные.СуммаОстаток;
				КонецЕсли;
				ОсталосьСписать = ОсталосьСписать - Списываем;
				
				Движение = Движения.ТоварыНаСкладах.ДобавитьПриход();
				Движение.Период = Дата;
				Движение.Номенклатура = ВыборкаНоменклатура.Номенклатура;
				Движение.Склад = СкладПолучатель;
				Движение.СрокГодности = ВыборкаДетальные.СрокГодности;
				Движение.Количество = Списываем;
				Если Списываем = ВыборкаДетальные.КоличествоОстаток Тогда
					Движение.Сумма = ВыборкаДетальные.СуммаОстаток;
				Иначе
					Движение.Сумма = Списываем / ВыборкаДетальные.КоличествоОстаток * ВыборкаДетальные.СуммаОстаток;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Не ЗначениеЗаполнено(АвторДокумента) Тогда
		АвторДокумента = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры