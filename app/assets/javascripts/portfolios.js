function parseDate(input, format) {
    format = format || 'yyyy-mm-dd'; // default format
    var parts = input.match(/(\d+)/g), 
        i = 0, fmt = {};
    // extract date-part indexes from the format
    format.replace(/(yyyy|dd|mm)/g, function(part) { fmt[part] = i++; });
  
    return new Date(parts[fmt['yyyy']], parts[fmt['mm']]-1, parts[fmt['dd']]);
}

var dateFormat = "dd/mm/yyyy";

$(document).on("turbolinks:load", function(){
    
    // Datepickers behaviour
    
    $('.datepicker').datepicker({
        format: dateFormat,
        autoclose: true,
        todayHighlight: true,
        endDate: new Date(),
        date: $(this).data().init
    });
    
    $('.datepicker').change(function(){
        var startDate = $('.datepicker.start').val();
        var finishDate = $('.datepicker.finish').val();
        
        if(startDate && finishDate) {
            startDate = parseDate(startDate, dateFormat);
            finishDate = parseDate(finishDate, dateFormat);
            $('.datepicker.finish').datepicker("setStartDate", startDate);
            $('.datepicker.start').datepicker("setEndDate", finishDate);
            
            if(finishDate < startDate) {
                $('.datepicker.finish').datepicker("update", new Date());
            }

            if($('#profit').length > 0) {
                $.ajax({
                    url: window.location.href + "/update_profit",
                    type: "get",
                    data: {
                        start_date: startDate,
                        finish_date: finishDate
                    }
                });
            } else if ($('#annual-profit').length > 0) {
                $.ajax({
                    url: "profit_by_year_chart",
                    type: "get",
                    data: {
                        start_date: startDate,
                        finish_date: finishDate                        
                    }
                });
            }
        }
        
    });

    if($('.datepicker').length > 0) {
        var initStart = $('.datepicker.start').data().init;
        var initFinish = $('.datepicker.finish').data().init;
    
        $('.datepicker.start').datepicker("update", initStart);
        $('.datepicker.finish').datepicker("update", initFinish);
    }
    
});