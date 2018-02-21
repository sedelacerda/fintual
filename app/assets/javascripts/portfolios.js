$(document).on("turbolinks:load", function(){
    
    // Datepickers behaviour
    
    $('.datepicker').datepicker({
        format: "dd/mm/yyyy",
        autoclose: true,
        todayHighlight: true,
        endDate: new Date(),
        date: $(this).data().init
    });
    
    $('.datepicker').change(function(){
        var startDate = $('.datepicker.start').val();
        var finishDate = $('.datepicker.finish').val();

        if(startDate && finishDate) {
            $('.datepicker.finish').datepicker("setStartDate", startDate);
            $('.datepicker.start').datepicker("setEndDate", finishDate);
    
            if(finishDate < startDate) {
                $('.datepicker.finish').datepicker("update", new Date());
            }
    
            $.ajax({
                url: window.location.href + "/update_profit",
                type: "get",
                data: {
                    start_date: startDate,
                    finish_date: finishDate
                }
            });
        }
        
    });

    if($('.datepicker').length > 0) {
        var initStart = $('.datepicker.start').data().init;
        var initFinish = $('.datepicker.finish').data().init;
    
        $('.datepicker.start').datepicker("update", initStart);
        $('.datepicker.finish').datepicker("update", initFinish);
    }



    
});