module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater on only in heating mode and too cold
    assign heater = mode & too_cold;

    // Aircon on only in cooling mode and too hot
    assign aircon = (~mode) & too_hot;

    // Fan on if heater or aircon on, or if user requests fan_on
    assign fan = heater | aircon | fan_on;

endmodule