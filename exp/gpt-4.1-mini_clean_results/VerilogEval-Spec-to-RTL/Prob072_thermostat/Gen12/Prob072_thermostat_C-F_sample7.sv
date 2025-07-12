module TopModule (
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output heater,    // Heater control output
    output aircon,    // Air conditioner control output
    output fan        // Fan control output
);

    wire heater_int;
    wire aircon_int;

    // Heater is on when heating mode is active and temperature too cold
    assign heater_int = mode & too_cold;

    // Aircon is on when cooling mode is active and temperature too hot
    assign aircon_int = (~mode) & too_hot;

    // Outputs driven from internal signals
    assign heater = heater_int;
    assign aircon = aircon_int;

    // Fan is on if heater or aircon is active, or user requests fan_on
    assign fan = heater_int | aircon_int | fan_on;

endmodule