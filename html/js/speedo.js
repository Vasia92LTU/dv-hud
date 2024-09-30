var debug = false;

// Main event listener for receiving data
window.addEventListener("message", (e) => {
    let data = e.data;

    if (data.action == "show") {
        $(".Main").css("display", "flex");
        New_Speed(parseInt(data.data.Speed), parseInt(data.data.MaxSpeed));
        New_Fuel(parseInt(data.data.Fuel));
        New_Gage(data.data.Rpm, 1);
        New_Damage(data.data.Damage, data.data.MaxDamage);

        // Update Lights, Lock, and Belts status
        data.data.Lights == 1
            ? $(".Lights-Container").addClass("Active-Control")
            : $(".Lights-Container").removeClass("Active-Control");
        data.data.Lock != 1
            ? $(".Door-Container").addClass("Active-Control")
            : $(".Door-Container").removeClass("Active-Control");
        data.data.Belts == true
            ? $(".Belt-Container").addClass("Active-Control")
            : $(".Belt-Container").removeClass("Active-Control");

        // Update the Speed unit (KM/H or MPH) display
        document.querySelector(".Speed-Counter").textContent = Math.round(
            data.data.Speed
        );
        document.querySelector(".Speed-KM").textContent = data.data.Unit;
        document.querySelector(".Speed-Container").style.display = "block";
    } else if (data.action == "hide") {
        $(".Main").css("display", "none");
        document.querySelector(".Speed-Container").style.display = "none";
    }
});



// Speed update function
function New_Speed(Speed, Max_Speed = 300) {
    var New_Speed_Bar = (Speed * 100) / Max_Speed;
    $(".Speed-Meter-Bar-Val").css("--Rate", New_Speed_Bar);
    $(".Speed-Counter").text(Speed);

    if (Speed <= 9) {
        $(":root").css("--Counter-Zero", '"00"');
    } else if (Speed <= 99) {
        $(":root").css("--Counter-Zero", '"0"');
    } else if (Speed > 99 && Speed < 1000) {
        $(":root").css("--Counter-Zero", '""');
    } else {
        $(":root").css("--Counter-Zero", '"what Da fuck?"');
    }
}

// Fuel update function
function New_Fuel($Fuel, $Max_Fuel = 100) {
    Fuel_Percentage = ($Fuel * 100) / $Max_Fuel;
    var New_Fuel_Bar = Math.round((Fuel_Percentage * 8) / 100);
    $(".Fuel").attr("data-Fuel", New_Fuel_Bar);
    $(".Fuel-Text").text($Fuel);
}

// Gauge update function
function New_Gage($Gage, $Max_Gage) {
    var Gage_Percentage = ($Gage * 100) / $Max_Gage;
    $(".Gage-Meter-Bar-Val").css("--Rate", Gage_Percentage);
}

// Damage update function
function New_Damage($Damage, $Max_Damage) {
    var Damage_Percentage2 = ($Damage / $Max_Damage) * 100;
    var Damage_Percentage = 100 - Damage_Percentage2;
    var Damage_Bar;
    if (Damage_Percentage >= 60) {
        Damage_Bar = (((Damage_Percentage - 60) / 40) * 100);
        $(".Damage-Meter-Bar-Val-1").css("--Rate", 100);
        $(".Damage-Meter-Bar-Val-2").css("--Rate", Damage_Bar);
    } else if (Damage_Percentage < 60 && Damage_Percentage >= 0) {
        Damage_Bar = ((Damage_Percentage / 60) * 100);
        $(".Damage-Meter-Bar-Val-1").css("--Rate", Damage_Bar);
        $(".Damage-Meter-Bar-Val-2").css("--Rate", 0);
    } else {
        $(".Damage-Meter-Bar-Val-1").css("--Rate", 0);
        $(".Damage-Meter-Bar-Val-2").css("--Rate", 0);
    }
}

$(document).ready(function () {
    if (debug) {
        var x = 0;
        var Dir = "Up";
        setInterval(function () {
            New_Speed(x);
            if (Dir == "Up") {
                x++;
            } else if (Dir == "Down") {
                x--;
            }
            if (x == 400) {
                Dir = "Down";
            } else if (x == 0) {
                Dir = "Up";
            }
        }, 20);

        var x2 = 1;
        var Dir2 = "Up";
        setInterval(function () {
            let Max_Fuel = 100;
            New_Fuel(x2, Max_Fuel);
            if (Dir2 == "Up") {
                x2++;
            } else if (Dir2 == "Down") {
                x2--;
            }
            if (x2 == Max_Fuel) {
                Dir2 = "Down";
            } else if (x2 == 0) {
                Dir2 = "Up";
            }
        }, 50);

        var x3 = 1;
        var Dir3 = "Up";
        setInterval(function () {
            let Max_Gage = 6;
            New_Gage(x3, Max_Gage);
            if (Dir3 == "Up") {
                x3++;
            } else if (Dir3 == "Down") {
                x3--;
            }
            if (x3 == Max_Gage) {
                Dir3 = "Down";
            } else if (x3 == 0) {
                Dir3 = "Up";
            }
        }, 500);

        setTimeout(function () {
            $(".Door-Container").addClass("Active-Control");
        }, 1000);
        setTimeout(function () {
            $(".Belt-Container").addClass("Active-Control");
        }, 2000);
        setTimeout(function () {
            $(".Lights-Container").addClass("Active-Control");
        }, 3000);
    }
});
