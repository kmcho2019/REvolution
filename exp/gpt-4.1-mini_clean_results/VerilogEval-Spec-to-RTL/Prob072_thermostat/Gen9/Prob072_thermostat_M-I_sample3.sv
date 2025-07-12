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

    // Intermediate active signal: heater or aircon active
    wire active = heater | aircon;

    // Fan on if active heating/cooling or user requests fan
    assign fan = active | fan_on;

endmodule