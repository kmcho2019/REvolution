module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is on only if mode is heating and too cold
    assign heater = (mode == 1'b1) ? too_cold : 1'b0;

    // Aircon is on only if mode is cooling and too hot
    assign aircon = (mode == 1'b0) ? too_hot : 1'b0;

    // Fan is on if either heater or aircon is active, or user forces fan_on
    assign fan = (heater | aircon) ? 1'b1 : fan_on;

endmodule