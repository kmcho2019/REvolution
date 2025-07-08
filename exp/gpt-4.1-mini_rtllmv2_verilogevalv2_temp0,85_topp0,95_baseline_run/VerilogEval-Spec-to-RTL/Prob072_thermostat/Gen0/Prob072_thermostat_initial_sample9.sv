module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is on only in heating mode and too_cold
    assign heater = mode & too_cold;
    // Aircon is on only in cooling mode and too_hot
    assign aircon = (~mode) & too_hot;
    // Fan is on if heater or aircon is on, or if fan_on is asserted
    assign fan = heater | aircon | fan_on;

endmodule