$(document).ready(function(){

    function display(bool) {
        if (bool) {
            $("body").show();
        } else {
            $("body").hide();
        }
    }

    function AnimationDisplay(bool) {
        if (bool) {
            setTimeout(function(){jQuery('body').fadeIn('show')}, 600);
        } else {
            $("body").fadeOut(400);
        }
    }
    display(false)
    var grade = false
    var permissions = null

    var gth, gtm = null
    
    var betterBank = true

    window.addEventListener('message', function(event) {
        myTimer()
        grade = false
        var item = event.data;
        if (item.type == "ui") {
            AnimationDisplay(true)

            ClearTheUI()
            $("#name").text(item.fullName)
            permissions = item.permissions
            betterBank = item.betterBank

            if (!betterBank) {
                $("#billPrice").attr("disabled", true);
                $("#billTextArea").attr("disabled", true);
                $("#createBill").text(lang["transferVehicle"]);
            } 
        }
        else if(item.type == "setupUI"){
            ClearTheUI()
            $("#carSelect").html('<option value="a"></option>')
            $("#closestPlayersBill").html('<option value="a"></option>')
            $("#billPrice").val("")
            $("#billTextArea").val("")
            gth = parseInt(item.time.h)
            gtm = parseInt(item.time.m)
            grade = item.grade
            $("#sirketisim").text(item.datas.name)
            // EMPLOYEES
                var i = 1
                var keys = Object.keys(item.datas.employees)
                employees = item.datas.employees
                if (!item.grade) {
                    $("#peral").attr("disabled", true);
                    $("#perkov").attr("disabled", true);
                }
                $("#numberEmp").text(keys.length)
                keys.forEach(key => {
                    employeesId.push("personel" + i)
                    $(".genelpersonelkutu").html($.parseHTML('<div id="personel'+i+'" class="personel" data-identifier="'+key+'" style="'+EmployeeHTMLIsFirst(i)+'"><span style="margin-bottom: 7%;"><b>'+employees[key].name+'</b></span><div style="display: inline-block; width: 85%; font-size: 20px;">'+lang["authority"]+'</div><div class="authorities"><span class="authority"><span class="authorityHolder"><input class="chbox" type="checkbox" id="delivery'+i+'" name="VD" value="yes" '+getChecked(employees[key].VD)+' '+EmployeeHTMLIsFirst(item.grade, true)+'><label class="authorityLabel" for="delivery'+i+'">'+lang["VD"]+'</label></span><span class="authorityHolder"><input class="chbox" type="checkbox" id="purchase'+i+'" name="VP" value="yes" '+getChecked(employees[key].VP)+ ' '+EmployeeHTMLIsFirst(item.grade, true)+' ><label class="authorityLabel" for="purchase'+i+'">'+lang["VP"]+'</label></span></span><span class="authority"><span class="authorityHolder"><input class="chbox" type="checkbox" id="sell'+i+'" name="SV" value="yes" '+getChecked(employees[key].SV)+' '+EmployeeHTMLIsFirst(item.grade, true)+'><label class="authorityLabel" for="sell'+i+'">'+lang["SV"]+'</label></span><span class="authorityHolder"><input class="chbox" type="checkbox" id="account'+i+'" name="AC" value="yes" '+getChecked(employees[key].AC)+' '+EmployeeHTMLIsFirst(item.grade, true)+'><label class="authorityLabel" for="account'+i+'">'+lang["AC"]+'</label></span></span></div></div>' + $(".genelpersonelkutu").html()));
                    i++;
                })
            //
            // purched cars
            var i = 1
            var keys = Object.keys(item.datas.cars)
            cars = item.datas.cars
            keys.forEach(key => {
                //main menu
                //main menu
                var v = cars[key]
                if (v.canTake == 0 ) { //takeable
                    $("#factory").text(parseInt($("#factory").text()) + 1)
                }else if (v.canTake == 1 || v.canTake == 2){
                    $("#ownedC").text(parseInt($("#ownedC").text()) + 1)
                }
                if(v.canTake == 2) {
                    $("#carSelect").html($.parseHTML($("#carSelect").html() + '<option value="'+v.id+'">'+v.carName +' ('+v.colorName+') - $'+addCommas((v.factoryPrice).toString())+'</option>'))
                }
                if(v.canTake == 3) {
                    $("#oldBillsHolder").html($.parseHTML($("#oldBillsHolder").html() + '<div class="oldBill"><div class="oldBillTop">'+item.datas.name+'</div><div class="billInsideLeft"><div><p class="oldBillColor">'+lang["seller"]+'</p><p class="colorBlack">'+v.billCreatorName+'</p></div><div style="margin-top: 20px;"><table class="colorBlack" style="border-collapse: collapse;"><thead><tr><th>'+lang["description"]+'</th><th style="width: 150px;">'+lang["color"]+'</th><th>'+lang["plate"]+'</th></tr></thead><tbody><tr><td>'+v.carName+'</td><td style="width: 150px; text-align: center;">'+v.colorName+'</td><td>'+v.carPlate+'</td></tr></tbody></table></div></div><div class="billInsideRight"><p class="oldBillColor textRight">'+lang["priceBill"]+'</p><p class="colorBlack textRight">'+addCommas((v.billAmount).toString())+'$</p><p style="margin-top: 10px;" class="oldBillColor textRight">'+lang["purchaser"]+'</p><p class="colorBlack textRight">'+v.billPayerName+'</p><p style="margin-top: 10px;" class="oldBillColor textRight">'+lang["date"]+'</p><p class="colorBlack textRight">'+v.billDate+'</p></div></div>'))
                }
                $("#carsHolder").html($.parseHTML('<div class="car">'+v.carName+'<p class="carName"></p><p class="carPrice">$'+addCommas((v.factoryPrice).toString())+',00</p><p class="carStatus">'+EmployeeHTMLIsInFactory(v.canTake, true, v.carPlate)+'</p><p class="carPlate"><b></b>'+EmployeeHTMLIsInFactory(v.canTake, false, v.carPlate)+'</p></div>' + $("#carsHolder").html()))
                i++;
            })
            // purched cars
        }else if (item.type == "closestPlayers") {
            $(".beyazdik").html("")
            $("#closestPlayersBill").html('<option value="a"></option>')
            item.players.forEach(function(v) {
                $("#closestPlayersBill").html($.parseHTML($("#closestPlayersBill").html() + '<option value="'+v.id+'">'+v.fullName+'</option>'))
                $(".beyazdik").html($.parseHTML('<span class="personelsecim" data-id="'+v.id+'">'+v.fullName+'</span>' + $(".beyazdik").html()))
              });
        }else if(item.type == "notify"){
            playAnim(item.text)
        }
    })

    var hire = false

    $("#createBill").click(function() {
        if ($("#closestPlayersBill option").filter(':selected').val() != "a" && $("#carSelect option").filter(':selected').val() != "a") {
            $("#closestPlayersBill").html()
            var price = 0
            if (betterBank) {
                price = $("#billPrice").val()
            }
            $.post('http://wiro_vehicleshop/createBill', JSON.stringify({
                carId: $("#carSelect option").filter(':selected').val(),
                targetId: $("#closestPlayersBill option").filter(':selected').val(),
                amount: price,
                label: $("#billTextArea").val(),
                vehicleShopName: $("#sirketisim").text()
            }));
        }
    });
    
    $("#cikisbtn").click(function() {
        AnimationDisplay(false)
        $.post('http://wiro_vehicleshop/exit', JSON.stringify());
    });

    $("#resell").click(function() {
        AnimationDisplay(false)
        $.post('http://wiro_vehicleshop/resell', JSON.stringify());
    });

    $(document).on('keyup', function(e) {
        if (e.key == "Escape") {
            if (hire) {
                $("#kararti").fadeOut();
                hire = false
            }else {
                AnimationDisplay(false)
                $.post('http://wiro_vehicleshop/exit', JSON.stringify());
            }
        }
      });

    $("#sirketisim").click(function() {
        $(".ortamenudeafulth").hide()
        $("#mainMenu").show()
        $("#mainMenu").attr("data-menu-name")
        $(".currentmenu").text("MAIN MENU")
    });

    $("#perkov").click(function() {
        $.post('http://wiro_vehicleshop/tryToFire', JSON.stringify({
            identifier: $(".personel:visible").attr("data-identifier")
        }));
        $(".personel:visible").remove()
        if ($(".genelpersonelkutu").children().first() != null) {
            $(".genelpersonelkutu").children().first().show()
        }
    });

    $(document).on('change', '.chbox', function() {
        $('.chbox').each(function() {
            $(this).attr({
                'disabled': 'disabled'
            });

        });
        $.post('http://wiro_vehicleshop/editEmployee', JSON.stringify({
            name: $(this).attr("name"),
            check: this.checked,
            identifier: $(this).parent().parent().parent().parent().data("identifier")
        }));
        setTimeout(function(){
            $('.chbox').each(function() {
                $(this).removeAttr('disabled');
            });
        }, 1000);

        
    });

    $(".icon").on( "click", function() {
        if ($(this).attr("data-menu-js") == "BANK" && (permissions == "boss" || permissions.AC)) {
            if (betterBank) {
                $.post('http://wiro_vehicleshop/companyBank', JSON.stringify());
                AnimationDisplay(false)
                ClearTheUI()
            }else {
                playAnim(lang["unavailable"])
            }
        }else if($(this).attr("data-menu-js") == "CREATE BILL" && (permissions == "boss" || permissions.SV)){
            $.post('http://wiro_vehicleshop/sendClosestPlayers', JSON.stringify());
            $(".ortamenudeafulth").hide()
            $("#" + $(this).attr("data-name")).show()
            $(".currentmenu").text($(this).attr("data-menu-name"))
        }else if ($(this).attr("data-menu-js") != "BANK" && $(this).attr("data-menu-js") != "CREATE BILL") {
            if ($(this).attr("data-menu-js") == "EMPLOYEES") {
                $.post('http://wiro_vehicleshop/sendClosestPlayers', JSON.stringify());
            }
            $(".ortamenudeafulth").hide()
            $("#" + $(this).attr("data-name")).show()
            $(".currentmenu").text($(this).attr("data-menu-name"))
        }
    });

    $(".fa-check-circle").click(function() {
        if (grade == 1) {
            $("#sirketisim").text($("#companyNameTextInput").val())
            $.post('http://wiro_vehicleshop/companyName', JSON.stringify({
                name: $("#companyNameTextInput").val()
            }));
        }
    });

    $("#peral").on( "click", function() {
        $("#kararti").fadeIn();
        hire = true
    });

    $(document).on("click", ".personelsecim",function() {
        $.post('http://wiro_vehicleshop/tryToHire', JSON.stringify({
            id: $(this).data("id")
        }));
    });

    var employeesId = []

    $("#solTus").on( "click", function() {
        var finish = false;
        $( ".personel" ).each(function( index ) {
            if ($(this).css("display") == "flex") {
                if (finish) {
                    return true;
                }
                $(this).hide();
                var nextElementIndex = 0
                if (parseInt(getKeyByValue(employeesId, $(this).attr("id"))) == 0) {
                    nextElementIndex = employeesId.length - 1
                }else {
                    nextElementIndex = parseInt(getKeyByValue(employeesId, $(this).attr("id"))) - 1
                }
                $("#" + employeesId[nextElementIndex]).show();
                finish = true;
            }
        });
    });

    $("#sagTus").on( "click", function() {
        var finish = false;
        $( ".personel" ).each(function( index ) {
            if ($(this).css("display") == "flex") {
                if (finish) {
                    return true;
                }
                $(this).hide();
                var nextElementIndex = 0
                if (parseInt(getKeyByValue(employeesId, $(this).attr("id"))) == employeesId.length - 1) {
                    nextElementIndex = 0
                }else {
                    nextElementIndex = parseInt(getKeyByValue(employeesId, $(this).attr("id"))) + 1
                }
                $("#" + employeesId[nextElementIndex]).show();
                finish = true;
            }
        });
    });

    var item = document.getElementById("carsHolder");

    window.addEventListener("wheel", function (e) {
      if (e.deltaY > 0) item.scrollLeft += 100;
      else item.scrollLeft -= 100;
    });

    var item2 = document.getElementById("oldBillsHolder");

    window.addEventListener("wheel", function (e) {
      if (e.deltaY > 0) item2.scrollLeft += 100;
      else item2.scrollLeft -= 100;
    });

    function getKeyByValue(object, value) {
        return Object.keys(object).find(key => object[key] === value);
      }

    // UTC time
    var myVar = setInterval(function() {
        myTimer();
        gtm = parseInt(gtm)
        gth = parseInt(gth)
        gtm++;
        if (gtm == 60) {
            gtm = 0
            gth++;
            if (gth == 24) {
                gth = 0
            }
        }
        if(gtm.toString().length == 1) {
            gtm = "0"+gtm.toString()
        }
        if(gth.toString().length == 1) {
            gth = "0"+gth.toString()
        }
        $("#gameClock").text(gth + ":" + gtm)
      }, 1000);
      
      function myTimer() {
        var time = new Date();
        data =
            ("0" + time.getHours()).slice(-2)   + ":" + 
            ("0" + time.getMinutes()).slice(-2);
        document.getElementById("utcClock").innerHTML = data + " UTC";
      }
    // UTC time

    function ClearTheUI() {
        $("#carsHolder").html("");
        $(".billSelect").html("");
        $("#billPrice").value = "";
        $("#billTextArea").value = "";
        $(".genelpersonelkutu").html("");
        $("#oldBillsHolder").html("")
        $("#factory").text("0")
        $("#ownedC").text("0")
        $(".ortamenudeafulth").hide()
        $("#mainMenu").show()
        $("#mainMenu").attr("data-menu-name")
        $("#carSelect").html('<option value="a"></option>')
        $("#closestPlayersBill").html('<option value="a"></option>')
        $("#billPrice").val("")
        $("#billTextArea").val("")
    }

    function getChecked(isMember) {
        return (isMember ? "checked" : "");
    }
    function EmployeeHTMLIsFirst(i, boss) { // for employees
        if (boss) {
            if (i == 1) {
                return ""
            }else {
                return "disabled"
            }
        }else {
            if (i == 1) {
                return ""
            }else {
                return "display: none;"
            }
        }
    }

    function EmployeeHTMLIsInFactory(i, fac, plate) { // for cars
        if (fac) {
            if (i == 1) {
                return lang["takeable"]
            }else if (i == 2) {
                return lang["taken"]
            }else if (i == 3) {
                return lang["selled"]
            }
            else {
                return lang["inFactory"]
            }
        }else {
            if (i != 0) {
                return plate
            }else {
                return lang["plateUnknown"]
            }
        }
    }

    function playAnim(text) {
        $("#animasyonText").text(text);
        setTimeout(function(){jQuery('#animasyon').fadeIn(1000)}, 500);
        setTimeout(function(){jQuery('#animasyon').fadeOut(1000)}, 3000);
    }

    function addCommas(inputText) {
        // pattern works from right to left
        var commaPattern = /(\d+)(\d{3})(\.\d*)*$/;
        var callback = function (match, p1, p2, p3) {
            return p1.replace(commaPattern, callback) + '.' + p2 + (p3 || '');
        };
        return inputText.replace(commaPattern, callback);
    }
});