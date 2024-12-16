﻿//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОкноПодгрузки = Новый Структура;
	ОкноПодгрузки.Вставить("Начало", ТекущаяДата());
	ОкноПодгрузки.Вставить("Конец", ТекущаяДата());

	ОтображатьВстречиДругихПользователей = РаботаСХранилищемОбщихНастроек.ПолучитьОтображениеВстречДругихПользователей();
	ПолучитьКодТекущегоПользователя();
	ЗаполнитьИзмеренияПланировщика();
	
	ВариантПериода = РаботаСХранилищемОбщихНастроек.ПолучитьВариантПериодаКалендаряВстреч();
	
	Планировщик.ШкалаВремени.Элементы[0].ФорматДня = ФорматДняШкалыВремени.ДеньМесяцаДеньНедели;
	
	ДатаОтображения = ТекущаяДата();
	ВыделитьПериодОтображения(ЭтотОбъект);
	ВыделитьДатыОтображения(ЭтотОбъект);
	УстановитьПредставлениеПериодаВЗаголовке(ЭтотОбъект);
	
	ОбновитьДанныеПланировщикаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьДанныеПланировщикаКлиент();
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтображенияПриИзменении(Элемент)
	
	ПлавнаяПрокрутка = Ложь;
	ПодключитьОбработчикОжидания("ОбновитьДанныеПланировщикаКлиентОбработчикОжидания", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтображенияПриАктивизацииДаты(Элемент)
	
	ВыделитьДатыОтображения(ЭтотОбъект);
	УстановитьПредставлениеПериодаВЗаголовке(ЭтотОбъект);
	Элементы.ДатаОтображения.Обновить();
	Элементы.ГруппаВыбораДат.Скрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередСозданием(Элемент, Начало, Конец, Значения, Текст, СтандартнаяОбработка) 	
	
	СтандартнаяОбработка = Ложь;
	
	Пользователь = Значения.Получить("Пользователь");		 	
	
	Если ТекущийПользовательБазы = Пользователь Или Пользователь = Неопределено Тогда    		
		ЗначенияЗаполнения = Новый Структура;              	
		ЗначенияЗаполнения.Вставить("Начало", Начало);
		ЗначенияЗаполнения.Вставить("Окончание", Конец);   	
		ЗначенияЗаполнения.Вставить("Владелец", Пользователь);  
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		ОткрытьФорму("Справочник.Встречи.Форма.ФормаЭлемента", ПараметрыФормы, ЭтотОбъект);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПриОкончанииРедактирования(Элемент, НовыйЭлемент, ОтменаРедактирования)
	
	ОбрабатываемыеЭлементы = Новый Массив;
	
	Для Каждого ВыделенныйЭлемент Из Элемент.ВыделенныеЭлементы Цикл
		
		Пользователь = ВыделенныйЭлемент.ЗначенияИзмерений.Получить("Пользователь");
		Если ТекущийПользовательБазы = Пользователь Или Пользователь = Неопределено Тогда 
			ОбрабатываемыйЭлемент = Новый Структура;
			ОбрабатываемыйЭлемент.Вставить("Встреча",	ВыделенныйЭлемент.Значение);
			ОбрабатываемыйЭлемент.Вставить("Начало",	ВыделенныйЭлемент.Начало);
			ОбрабатываемыйЭлемент.Вставить("Конец",		ВыделенныйЭлемент.Конец);  		
			
			ОбрабатываемыйЭлемент.Вставить("Владелец", Пользователь); 
			ОбрабатываемыеЭлементы.Добавить(ОбрабатываемыйЭлемент);
		Иначе
			ОтменаРедактирования = Истина;
			Прервать;
		КонецЕсли;
				
	КонецЦикла; 	
	Если Не ОтменаРедактирования Тогда
		ОтменаРедактирования = Не СохранитьИзмененияВБазу(ОбрабатываемыеЭлементы);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередНачаломРедактирования(Элемент, НовыйЭлемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НовыйЭлемент Тогда
		ОткрытьФормуТекущегоЭлементаПланировщика();
	Иначе
		ЭлементПланировщика = Элемент.ВыделенныеЭлементы[0];
		Пользователь = ЭлементПланировщика.ЗначенияИзмерений.Получить("Пользователь");		 	
	
		Если ТекущийПользовательБазы = Пользователь Или Пользователь = Неопределено Тогда  
			ОткрытьФормуТекущегоЭлементаПланировщика();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередУдалением(Элемент, Отказ)
	
	ОбрабатываемыеЭлементы = Новый Массив;
	
	Для Каждого ВыделенныйЭлемент Из Элемент.ВыделенныеЭлементы Цикл
		
		ОбрабатываемыйЭлемент = Новый Структура;
		ОбрабатываемыйЭлемент.Вставить("Встреча", ВыделенныйЭлемент.Значение);
		ОбрабатываемыйЭлемент.Вставить("ПометкаУдаления", Истина);
		
		ОбрабатываемыеЭлементы.Добавить(ОбрабатываемыйЭлемент);
		
	КонецЦикла;
	
	Отказ = Не СохранитьИзмененияВБазу(ОбрабатываемыеЭлементы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПриСменеТекущегоПериодаОтображения(Элемент, ТекущиеПериодыОтображения, СтандартнаяОбработка)
	
	ПлавнаяПрокрутка = Истина;
	Если ВариантПериода = "Месяц" Тогда
		
		СтандартнаяОбработка = Ложь;
		ТекущаяДата = ТекущаяДата();
		
		Если ТекущиеПериодыОтображения[0].Начало = НачалоДня(ТекущаяДата) Тогда
			ДатаОтображения = ТекущаяДата;
		ИначеЕсли ТекущиеПериодыОтображения[0].Начало < Планировщик.ТекущиеПериодыОтображения[0].Начало Тогда
			ДатаОтображения = ДобавитьМесяц(ДатаОтображения, -1);
		ИначеЕсли ТекущиеПериодыОтображения[0].Начало > Планировщик.ТекущиеПериодыОтображения[0].Начало Тогда
			ДатаОтображения = ДобавитьМесяц(ДатаОтображения, 1);
		КонецЕсли;
		
		ПериодДанных = ПолучитьПериодДанных(ВариантПериода, ДатаОтображения);
		Планировщик.ТекущиеПериодыОтображения.Очистить();
		Планировщик.ТекущиеПериодыОтображения.Добавить(ПериодДанных.ДатаНачала, ПериодДанных.ДатаОкончания);
		
		Планировщик.ИнтервалыФона.Очистить();
		Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоНедели(НачалоМесяца(ДатаОтображения)), НачалоМесяца(ДатаОтображения));
		Интервал.Цвет = Новый Цвет(230, 230, 230);
		
		Интервал = Планировщик.ИнтервалыФона.Добавить(КонецМесяца(ДатаОтображения), КонецНедели(КонецМесяца(ДатаОтображения)));
		Интервал.Цвет = Новый Цвет(230, 230, 230);
			
		Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоДня(ТекущаяДата), КонецДня(ТекущаяДата));
	    Интервал.Цвет = Новый Цвет(223, 255, 223);
		
		ПлавнаяПрокрутка = Ложь;
		
	Иначе
		
		ДатаОтображения = ТекущиеПериодыОтображения[0].Начало;
		
	КонецЕсли;
	
	ВыделитьДатыОтображения(ЭтотОбъект);
	УстановитьПредставлениеПериодаВЗаголовке(ЭтотОбъект);
	Элементы.ДатаОтображения.Обновить();
	ОбновитьДанныеПланировщикаКлиент(ПлавнаяПрокрутка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередНачаломБыстрогоРедактирования(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуТекущегоЭлементаПланировщика();
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикНажатиеНаПеренесенномЗаголовкеШкалыВремени(Элемент, Дата)
	
	Если ВариантПериода = "Неделя" Тогда
		ВариантПериода = "День";
		ДатаОтображения = НачалоДня(Дата);
		ПриИзмененииВариантПериода();
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикНажатиеНаЭлементеШкалыВремени(Элемент, ЭлементШкалыВремени, Дата)

	Если ВариантПериода = "Месяц" Тогда
		ВариантПериода = "День";
		ДатаОтображения = НачалоДня(Дата);
		ПриИзмененииВариантПериода();
	КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПланировщикНажатиеНаЭлементеИзмерения(Элемент, ЭлементИзмерения, ЗначенияИзмерений, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Пользователь = ПолучитьПользователяПоКоду(ЭлементИзмерения.Значение);
	ПараметрыФормы = Новый Структура("Ключ", Пользователь);
	ОткрытьФорму("Справочник.Пользователи.Форма.ФормаЭлемента", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьВстречиДругихПользователейПриИзменении(Элемент)
	
	РаботаСХранилищемОбщихНастроек.СохранитьОтображениеВстречДругихПользователей(ОтображатьВстречиДругихПользователей);
	ПолучитьКодТекущегоПользователя();
	ЗаполнитьИзмеренияПланировщика();
	ОбновитьДанныеПланировщикаКлиент();
	
КонецПроцедуры


//////////////////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ И ФУНКЦИИ 
//

// Возвращает период отображения Планировщика на основе текущих настроек
//
// Параметры:
//
// ВариантПериода - день/неделя/месяц для текущей даты
// ДатаОтображения - текущая дата отображения
//
// Возвращаемое значение: 
// Структура - дата начала и дата окончания периода.
&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПериодДанных(ВариантПериода, ДатаОтображения)
	
	Результат = Новый Структура("ДатаНачала, ДатаОкончания");
	
	Если ВариантПериода = "День" Тогда
		Результат.ДатаНачала	= НачалоДня(ДатаОтображения);
		Результат.ДатаОкончания	= КонецДня(ДатаОтображения);
	ИначеЕсли ВариантПериода = "Неделя" Тогда
		Результат.ДатаНачала	= НачалоНедели(ДатаОтображения);
		Результат.ДатаОкончания	= КонецНедели(ДатаОтображения);
	ИначеЕсли ВариантПериода = "Месяц" Тогда
		Результат.ДатаНачала	= НачалоНедели(НачалоМесяца(ДатаОтображения));
		Результат.ДатаОкончания	= КонецНедели(КонецМесяца(ДатаОтображения));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Выделяет соотвествующие даты в поле календаря
//
// Параметры:
//
// Форма - форма, в которой расположен календарь
&НаКлиентеНаСервереБезКонтекста
Процедура ВыделитьДатыОтображения(Форма)
	
	ПолеКалендаря = Форма.Элементы.ДатаОтображения;
	
	ПолеКалендаря.ВыделенныеДаты.Очистить();
	
	Если Форма.ВариантПериода = "Месяц" Тогда
		// Для варианта "Месяц" выделенные даты календаря отличаются от фактического периода.
		// Фактический период должен быть кратен 7 дням (недели).
		// Но в поле календаря выделяются даты только в пределах месяца.
		ПериодДанных = Новый Структура("ДатаНачала, ДатаОкончания");
		ПериодДанных.ДатаНачала		= НачалоМесяца(Форма.ДатаОтображения);
		ПериодДанных.ДатаОкончания	= КонецМесяца(Форма.ДатаОтображения);
	Иначе
		ПериодДанных = ПолучитьПериодДанных(Форма.ВариантПериода, Форма.ДатаОтображения);
	КонецЕсли;
	
	ТекДата = ПериодДанных.ДатаНачала;
	
	Пока ТекДата < ПериодДанных.ДатаОкончания Цикл
		ПолеКалендаря.ВыделенныеДаты.Добавить(ТекДата);
		ТекДата = ТекДата + 86400;
	КонецЦикла;
	
КонецПроцедуры

// Выделяет соотвествующий период отображения
//
// Параметры:
//
// Форма - форма, в которой расположен календарь
&НаКлиентеНаСервереБезКонтекста
Процедура ВыделитьПериодОтображения(Форма)
	
	Форма.Элементы.ФормаДень.Пометка = Ложь;
	Форма.Элементы.ФормаНеделя.Пометка = Ложь;
	Форма.Элементы.ФормаМесяц.Пометка = Ложь;
	
	Если Форма.ВариантПериода = "День" Тогда
		Форма.Элементы.ФормаДень.Пометка = Истина;
	ИначеЕсли Форма.ВариантПериода = "Неделя" Тогда
		Форма.Элементы.ФормаНеделя.Пометка = Истина;
	ИначеЕсли Форма.ВариантПериода = "Месяц" Тогда
		Форма.Элементы.ФормаМесяц.Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры


// Сохраняет измененные встречи в справочнике
//
// Параметры:
//
// ОбрабатываемыеЭлементы - массив измененнных встреч
//
// Возвращаемое значение: 
// Булево - данные были успешно сохранены
&НаСервереБезКонтекста
Функция СохранитьИзмененияВБазу(Знач ОбрабатываемыеЭлементы)
	
	Возврат Справочники.Встречи.СохранитьИзменения(ОбрабатываемыеЭлементы);
	
КонецФункции

// Устанавливает заголовок формы, соотвествующий представлению отображаемого периода на основе текущих настроек
//
// Параметры:
//
// Форма - форма, в которой расположен элемент представления
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеПериодаВЗаголовке(Форма)
	
	Если Форма.ВариантПериода = "День" Тогда
		
		Форма.Заголовок = Формат(Форма.ДатаОтображения, "ДФ='ddd, d MMM yyyy'");
		
	ИначеЕсли Форма.ВариантПериода = "Неделя" Тогда
		
		ПериодДанных = ПолучитьПериодДанных(Форма.ВариантПериода, Форма.ДатаОтображения);
		Форма.Заголовок = СтрШаблон(
			"%1 - %2",
			Формат(ПериодДанных.ДатаНачала, "ДФ='d MMM'"),
			Формат(ПериодДанных.ДатаОкончания, "ДФ='d MMM yyyy'")
		);
		
	ИначеЕсли Форма.ВариантПериода = "Месяц" Тогда
		
		Форма.Заголовок = ПредставлениеПериода(НачалоМесяца(Форма.ДатаОтображения), КонецМесяца(Форма.ДатаОтображения));
		
	КонецЕсли;
	
КонецПроцедуры

// Настраивает отображение Планировщика на основе текущих настроек
&НаКлиенте
Процедура УстановитьОтображениеПланировщика()
	
	Если ВариантПериода = "День" Тогда
		
		Элементы.Планировщик.ГиперссылкаПеренесенногоЗаголовкаШкалыВремени = Ложь;
		Элементы.Планировщик.ГиперссылкаЭлементаШкалыВремени = Ложь;
		Планировщик.ФиксироватьЗаголовокШкалыВремени = Истина;
		Планировщик.ОтображатьТекущуюДату = Истина;
		Планировщик.ЕдиницаПериодическогоВарианта = ТипЕдиницыШкалыВремени.Час;
		Планировщик.КратностьПериодическогоВарианта = 24;
		Планировщик.ОтступСНачалаПереносаШкалыВремени = 9;
		Планировщик.ОтступСКонцаПереносаШкалыВремени = 6;
		Планировщик.ОтображатьПеренесенныеЗаголовки = Истина;
		Планировщик.ОтображатьПеренесенныеЗаголовкиШкалыВремени = Ложь;
		Планировщик.ОтображениеВремениЭлементов = ОтображениеВремениЭлементовПланировщика.ВремяНачала;
		Планировщик.ФорматПеренесенныхЗаголовковШкалыВремени = "ДФ='ddd" + Символы.ПС + "d MMMM'";
		Планировщик.ШкалаВремени.Положение = ПоложениеШкалыВремени.Лево;
		Планировщик.ШкалаВремени.Элементы[0].Формат = "ДФ=HH:mm";
		Планировщик.ШкалаВремени.Элементы[0].Кратность = 1;
		Планировщик.ШкалаВремени.Элементы[0].Единица = ТипЕдиницыШкалыВремени.Час;
		
		Если Планировщик.ШкалаВремени.Элементы.Количество() = 1 Тогда
			Планировщик.ШкалаВремени.Элементы.Добавить();
		КонецЕсли;
			
		Планировщик.ШкалаВремени.Элементы[1].Кратность = 30;
		Планировщик.ШкалаВремени.Элементы[1].Единица = ТипЕдиницыШкалыВремени.Минута;
		Планировщик.ШкалаВремени.Элементы[1].ОтображатьПериодическиеМетки = Ложь;
		
	ИначеЕсли ВариантПериода = "Неделя" Тогда
		
		Элементы.Планировщик.ГиперссылкаПеренесенногоЗаголовкаШкалыВремени = Истина;
		Элементы.Планировщик.ГиперссылкаЭлементаШкалыВремени = Ложь;
		Планировщик.ФиксироватьЗаголовокШкалыВремени = Истина;
		Планировщик.ОтображатьТекущуюДату = Истина;
		Планировщик.ЕдиницаПериодическогоВарианта = ТипЕдиницыШкалыВремени.Час;
		Планировщик.КратностьПериодическогоВарианта = 24;
		Планировщик.ОтступСНачалаПереносаШкалыВремени = 9;
		Планировщик.ОтступСКонцаПереносаШкалыВремени = 6;
		Планировщик.ОтображатьПеренесенныеЗаголовки = Истина;
		Планировщик.ОтображатьПеренесенныеЗаголовкиШкалыВремени = Ложь;
		Планировщик.ОтображениеВремениЭлементов = ОтображениеВремениЭлементовПланировщика.НеОтображать;
		Планировщик.ФорматПеренесенныхЗаголовковШкалыВремени = "ДФ='ddd" + Символы.ПС + "d MMMM'";
		Планировщик.ШкалаВремени.Положение = ПоложениеШкалыВремени.Лево;
		Планировщик.ШкалаВремени.Элементы[0].Формат = "ДФ=HH:mm";
		Планировщик.ШкалаВремени.Элементы[0].Кратность = 1;
		Планировщик.ШкалаВремени.Элементы[0].Единица = ТипЕдиницыШкалыВремени.Час;
		
		Если Планировщик.ШкалаВремени.Элементы.Количество() = 1 Тогда
			Планировщик.ШкалаВремени.Элементы.Добавить();
		КонецЕсли;
		
		Планировщик.ШкалаВремени.Элементы[1].Кратность = 30;
		Планировщик.ШкалаВремени.Элементы[1].Единица = ТипЕдиницыШкалыВремени.Минута;
		Планировщик.ШкалаВремени.Элементы[1].ОтображатьПериодическиеМетки = Ложь;
		
	ИначеЕсли ВариантПериода = "Месяц" Тогда
		
		Элементы.Планировщик.ГиперссылкаПеренесенногоЗаголовкаШкалыВремени = Ложь;
		Элементы.Планировщик.ГиперссылкаЭлементаШкалыВремени = Истина;
		Планировщик.ФиксироватьЗаголовокШкалыВремени = Ложь;
		Планировщик.ОтображатьТекущуюДату = Ложь;
		Планировщик.ЕдиницаПериодическогоВарианта = ТипЕдиницыШкалыВремени.День;
		Планировщик.КратностьПериодическогоВарианта = 7;
		Планировщик.ОтступСНачалаПереносаШкалыВремени = 0;
		Планировщик.ОтступСКонцаПереносаШкалыВремени = 0;
		Планировщик.ОтображатьПеренесенныеЗаголовки = Ложь;
		Планировщик.ОтображатьПеренесенныеЗаголовкиШкалыВремени = Истина;
		Планировщик.ОтображениеВремениЭлементов = ОтображениеВремениЭлементовПланировщика.НеОтображать;
		Планировщик.ШкалаВремени.Положение = ПоложениеШкалыВремени.Верх;
		
		Если Планировщик.ШкалаВремени.Элементы.Количество() = 2 Тогда
			Планировщик.ШкалаВремени.Элементы.Удалить(Планировщик.ШкалаВремени.Элементы.Получить(1));
		КонецЕсли;
		
		Планировщик.ШкалаВремени.Элементы[0].Формат = "ДФ='" + Символы.НПП + "d MMM, ddd'";
		Планировщик.ШкалаВремени.Элементы[0].Кратность = 1;
		Планировщик.ШкалаВремени.Элементы[0].Единица = ТипЕдиницыШкалыВремени.День;
		
		
		Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоНедели(НачалоМесяца(ДатаОтображения)), НачалоМесяца(ДатаОтображения));
		Интервал.Цвет = Новый Цвет(230, 230, 230);
		
		Интервал = Планировщик.ИнтервалыФона.Добавить(КонецМесяца(ДатаОтображения), КонецНедели(КонецМесяца(ДатаОтображения)));
		Интервал.Цвет = Новый Цвет(230, 230, 230);

		ТекущаяДата = ТекущаяДата();
		Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоДня(ТекущаяДата), КонецДня(ТекущаяДата));
		Интервал.Цвет = Новый Цвет(223, 255, 223);
		
	КонецЕсли;
	
	Если ОтображатьВстречиДругихПользователей Тогда
		
		//ПолучитьКодТекущегоПользователя();
		
		СоответствиеЗначений = Новый Соответствие;
		СоответствиеЗначений.Вставить("Пользователь", ТекущийПользовательБазы);
	
		ПериодДанных = ПолучитьПериодДанных(ВариантПериода, ДатаОтображения);
		Интервал = Планировщик.ИнтервалыФона.Добавить(ОкноПодгрузки.Начало, ОкноПодгрузки.Конец);
		Интервал.Цвет = Новый Цвет(223, 223, 255);
		Интервал.ЗначенияИзмерений = Новый ФиксированноеСоответствие(СоответствиеЗначений);
	КонецЕсли;
	
КонецПроцедуры

// Получает с сервера список пользователей для задания измерений Планировщика
&НаСервере
Процедура ЗаполнитьИзмеренияПланировщика()
	Планировщик.Измерения.Очистить();
	Если ОтображатьВстречиДругихПользователей Тогда
		ИзмерениеПланировщика = Неопределено;
		ПользователиБазы = Справочники.Пользователи.Выбрать();
		Пока ПользователиБазы.Следующий() Цикл
			Если Не ПользователиБазы.ПометкаУдаления = Истина Тогда
				Если ИзмерениеПланировщика = Неопределено Тогда
					ИзмерениеПланировщика = Планировщик.Измерения.Добавить("Пользователь");
				КонецЕсли;
				ЭлементИзмерения = ИзмерениеПланировщика.Элементы.Добавить(ПользователиБазы.Код);
				Если ТекущийПользовательБазы = ПользователиБазы.Код Тогда
					ЭлементИзмерения.Текст = Новый ФорматированнаяСтрока(ПользователиБазы.Наименование, Новый Шрифт(,, Истина), WebЦвета.Серый);
				Иначе
					ЭлементИзмерения.Текст = ПользователиБазы.Наименование;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Получает с сервера измерение, соответствующее текущему пользователю
&НаСервере
Процедура ПолучитьКодТекущегоПользователя()
	ТекущийПользовательБазы = "" + ПользователиИнформационнойБазы.ТекущийПользователь();
КонецПроцедуры

// Обновляет параметры планировщика, которые можно получить только на сервере
//
// Параметры:
//
// ПлавнаяПрокрутка - данные обновляются в результате прокрутки колесом и, возможно, подгрузка новых втреч не требуется
&НаСервере
Процедура ОбновитьДанныеПланировщикаСервер(ПлавнаяПрокрутка = Ложь)
	
	Если ПлавнаяПрокрутка Тогда
		Планировщик.Элементы.УдалитьНеиспользуемые();
	Иначе
		Планировщик.Элементы.Очистить();
	КонецЕсли;
	
	МассивЗагружаемыхПользователей = Новый Массив();
	
	Если ОтображатьВстречиДругихПользователей Тогда
		ПользователиБазы = Справочники.Пользователи.Выбрать();
		Пока ПользователиБазы.Следующий() Цикл
			Если Не ПользователиБазы.ПометкаУдаления = Истина Тогда
				МассивЗагружаемыхПользователей.Добавить(ПользователиБазы.Код);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Пользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
		МассивЗагружаемыхПользователей.Добавить(Пользователь);
	КонецЕсли;
	
	Для Каждого Пользователь из МассивЗагружаемыхПользователей Цикл
		Владелец = Справочники.Пользователи.НайтиПоКоду(Пользователь);
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Встречи.Ссылка КАК Встреча,
		|	Встречи.Наименование КАК Наименование,
		|	Встречи.Начало КАК Начало,
		|	Встречи.Окончание КАК Конец,
		|	Встречи.Описание КАК Описание
		|ИЗ
		|	Справочник.Встречи КАК Встречи
		|ГДЕ
		|	Встречи.ПометкаУдаления = ЛОЖЬ
		|	И Встречи.Начало < &ДатаОкончания
		|	И Встречи.Окончание > &ДатаНачала
		|	И Встречи.Владелец = &Пользователь
		|
		|УПОРЯДОЧИТЬ ПО
		|	Начало";
		
		Запрос.УстановитьПараметр("ДатаНачала", ОкноПодгрузки.Начало);
		Запрос.УстановитьПараметр("ДатаОкончания", ОкноПодгрузки.Конец);
		Запрос.УстановитьПараметр("Пользователь", Владелец);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Значение = Выборка.Встреча;
			Если Планировщик.Элементы.Найти(Значение) = Неопределено Тогда
				ЭлементПланировщика = Планировщик.Элементы.Добавить(Выборка.Начало, Выборка.Конец);
				ЭлементПланировщика.Значение 	= Значение; 		
				ЭлементПланировщика.ЦветТекста 	= Новый Цвет(70, 70, 70);
				ЭлементПланировщика.Текст		= Новый ФорматированнаяСтрока(Выборка.Наименование, , Планировщик.ЦветТекста);
				ЭлементПланировщика.Подсказка	= Выборка.Описание;

				ВладелецЭлемента = Значение.Владелец.Код;
				Если ТекущийПользовательБазы = ВладелецЭлемента Тогда
					ДействиеПеренести = ЭлементПланировщика.Действия.Добавить("ДействиеПеренестиНаСледующийДень", "", БиблиотекаКартинок.ПланировщикПеренестиНаСЛедующийДень); 
					ДействиеПеренести.Подсказка = НСтр("ru ='Перенести на следующий день'", "ru"); 				
					ДействиеПеренести.Положение = ПоложениеДействияЭлементаПланировщика.ПослеТекста; 
				Иначе
					ЭлементПланировщика.РежимРазрешенияРедактирования = РежимРазрешенияРедактированияЭлементаПланировщика.ЗапретитьРедактирование; 
				КонецЕсли;
				
				Если МассивЗагружаемыхПользователей.Количество() > 1 Тогда
					СоответствиеЗначений = Новый Соответствие;
					СоответствиеЗначений.Вставить("Пользователь", Пользователь);
					ЭлементПланировщика.ЗначенияИзмерений  = Новый ФиксированноеСоответствие(СоответствиеЗначений);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// Польностью обновляет данные Планировщика
&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДанныеПланировщикаКлиент();
	
КонецПроцедуры

// Открывает форму редактирования выбраной встречи
&НаКлиенте
Процедура ОткрытьФормуТекущегоЭлементаПланировщика()
	
	ЗначениеЭлемента = Элементы.Планировщик.ВыделенныеЭлементы[0].Значение;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ЗначениеЭлемента);
	ОткрытьФорму("Справочник.Встречи.Форма.ФормаЭлемента", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

// Обработчик ожидания обновления данные Планировщика
&НаКлиенте
Процедура ОбновитьДанныеПланировщикаКлиентОбработчикОжидания() Экспорт
	
	ОбновитьДанныеПланировщикаКлиент();
	
КонецПроцедуры

// Обновляет данные Планировщика
&НаКлиенте
Процедура ОбновитьДанныеПланировщикаКлиент(ПлавнаяПрокрутка = Ложь)
	
	ПериодДанных = ПолучитьПериодДанных(ВариантПериода, ДатаОтображения);
	
	// ОбновлениеЭлементов
	НужноПодгрузитьЭлементы = Ложь;
	
	Если ПлавнаяПрокрутка Тогда
		Если ОкноПодгрузки.Конец <= ПериодДанных.ДатаОкончания 
			ИЛИ ОкноПодгрузки.Начало >= ПериодДанных.ДатаНачала Тогда
			НужноПодгрузитьЭлементы = Истина;
		КонецЕсли;
	Иначе
		НужноПодгрузитьЭлементы = Истина;
	КонецЕсли;
	
	Если НужноПодгрузитьЭлементы Тогда
		ОбновитьОкноПодгрузки();
		ОбновитьДанныеПланировщикаСервер(ПлавнаяПрокрутка);
	КонецЕсли;
	
	Если Не ПлавнаяПрокрутка ИЛИ НужноПодгрузитьЭлементы Тогда
		// ВнешнийВидПланировщика
		Планировщик.ИнтервалыФона.Очистить();
		УстановитьОтображениеПланировщика();
	КонецЕсли;

	
	Если Не ПлавнаяПрокрутка Тогда
		Планировщик.ТекущиеПериодыОтображения.Очистить();
		Планировщик.ТекущиеПериодыОтображения.Добавить(ПериодДанных.ДатаНачала, ПериодДанных.ДатаОкончания);
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает входящее оповещение
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Встречи" Тогда
	
		ОбновитьДанныеПланировщикаКлиент();
		
	КонецЕсли;
	
КонецПроцедуры

// Обновляет окно, внутри которого кэшируются встречи
&НаКлиенте
Процедура ОбновитьОкноПодгрузки()
	ПериодДанных = ПолучитьПериодДанных(ВариантПериода, ДатаОтображения);
	
	Если ВариантПериода = "Месяц" Тогда
		ОкноПодгрузки.Начало = ДобавитьМесяц(ПериодДанных.ДатаНачала, 0);
		ОкноПодгрузки.Конец = ДобавитьМесяц(ПериодДанных.ДатаОкончания, 0);
	ИначеЕсли ВариантПериода = "Неделя" Тогда
		ОкноПодгрузки.Начало = ПериодДанных.ДатаНачала - 3 * 7 * 24 * 60 * 60;
		ОкноПодгрузки.Конец = ПериодДанных.ДатаОкончания + 3 * 7 * 24 * 60 * 60;
	ИначеЕсли ВариантПериода = "День" Тогда
		ОкноПодгрузки.Начало = ПериодДанных.ДатаНачала - 3 * 24 * 60 * 60;
		ОкноПодгрузки.Конец = ПериодДанных.ДатаОкончания + 3 * 24 * 60 * 60;
	КонецЕсли
	
КонецПроцедуры

// Возвращает ссылку на элемент справочника "Пользователи" по коду
&НаСервереБезКонтекста
Функция ПолучитьПользователяПоКоду(КодПользователя)
	
	Возврат Справочники.Пользователи.НайтиПоКоду(КодПользователя);
	
КонецФункции

// Переключает вариант периода на "День"
&НаКлиенте
Процедура ФормаДень(Команда)
	
	ВариантПериода = "День";
	ПриИзмененииВариантПериода();
	
КонецПроцедуры

// Переключает вариант периода на "Неделя"
&НаКлиенте
Процедура ФормаНеделя(Команда)
	
	ВариантПериода = "Неделя";
	ПриИзмененииВариантПериода();
	
КонецПроцедуры

// Переключает вариант периода на "Месяц"
&НаКлиенте
Процедура ФормаМесяц(Команда)
	ВариантПериода = "Месяц";
	ПриИзмененииВариантПериода();
		
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВКалендарь(Кто, ДатаНачала, ДатаКонца, Наименование)
	запись = Справочники.Встречи.СоздатьЭлемент();
	запись.Владелец = Кто;
	запись.Начало = ДатаНачала;
	запись.Окончание = ДатаКонца;
	запись.Описание = Наименование;
	запись.Наименование = Наименование;
	запись.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииВариантПериода()
	
	РаботаСХранилищемОбщихНастроек.СохранитьВариантПериодаКалендаряВстреч(ВариантПериода);
	
	ВыделитьДатыОтображения(ЭтотОбъект);
	ВыделитьПериодОтображения(ЭтотОбъект);
	УстановитьПредставлениеПериодаВЗаголовке(ЭтотОбъект);
	Элементы.ДатаОтображения.Обновить();
	ОбновитьДанныеПланировщикаКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтображенияВыбор(Элемент, ВыбраннаяДата)
	Элементы.ГруппаВыбораДат.Скрыть();	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиНаСледующийДень(ЭлементПланировщика) Экспорт
	ОбрабатываемыеЭлементы = Новый Массив;
	ОбрабатываемыйЭлемент = Новый Структура;
	Сутки = 24 * 60 * 60;
	ОбрабатываемыйЭлемент.Вставить("Встреча",	ЭлементПланировщика.Значение);
	ОбрабатываемыйЭлемент.Вставить("Начало",	ЭлементПланировщика.Начало + Сутки);
	ОбрабатываемыйЭлемент.Вставить("Конец",		ЭлементПланировщика.Конец + Сутки);  		
	Если Планировщик.Измерения.Количество() = 0 Тогда
		ОбрабатываемыйЭлемент.Вставить("Владелец",	Неопределено);
	Иначе
		ОбрабатываемыйЭлемент.Вставить("Владелец", ЭлементПланировщика.ЗначенияИзмерений.Получить("Пользователь"));
	КонецЕсли;
	
	ОбрабатываемыеЭлементы.Добавить(ОбрабатываемыйЭлемент);
	СохранитьИзмененияВБазу(ОбрабатываемыеЭлементы);  
	ОбновитьДанныеПланировщикаКлиент();  
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикНажатиеНаДействиеПланировщика(Элемент, ЭлементПланировщика, Действие)
	Если Действие.Значение = "ДействиеПеренестиНаСледующийДень" Тогда
		ПеренестиНаСледующийДень(ЭлементПланировщика)   
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПланировщикОбработкаФормированияКоманд(Элемент, Параметры, Команды, КомандаПоУмолчанию)
	Источник = Параметры.Источник; 	
	
	Если Источник = ИсточникКомандПланировщика.Элементы и Параметры.Элементы.Количество() = 1 Тогда
		ЭлементПланировщика = Параметры.Элементы.Получить(0);
		Владелец = ЭлементПланировщика.ЗначенияИзмерений.Получить("Пользователь");
		Если Владелец = ТекущийПользовательБазы Или Владелец = Неопределено Тогда
			ПеренестиНаСледующийДень = Новый ОписаниеКомандыПланировщика(Новый ОписаниеОповещения("ПеренестиНаСледующийДень", ЭтаФорма, ЭлементПланировщика), НСтр("ru ='Перенести на следующий день'", "ru"));
			ПеренестиНаСледующийДень.Картинка = БиблиотекаКартинок.ПланировщикПеренестиНаСледующийДень;
			Команды.Добавить(ПеренестиНаСледующийДень);
		Иначе
			Команды.Очистить();
		КонецЕсли; 
	ИначеЕсли Источник = ИсточникКомандПланировщика.ПустаяОбластьЭлементов Тогда
		Владелец = Параметры.ЗначенияИзмерений.Получить("Пользователь");	
		Если Владелец <> ТекущийПользовательБазы И Владелец <> Неопределено Тогда
			Команды.Очистить();
		КонецЕсли;                    		
	КонецЕсли;
КонецПроцедуры 



