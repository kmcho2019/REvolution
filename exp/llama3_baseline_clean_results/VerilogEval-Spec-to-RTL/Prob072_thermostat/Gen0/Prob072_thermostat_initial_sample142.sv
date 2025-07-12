module TopModule(
    input  mode,        // 1 for heating mode, 0 for cooling mode
    input  too_cold,    // 1 if it's too cold
    input  too_hot,     // 1 if it's too hot
    input  fan_on,      // 1 to turn on the fan manually
    output heater,      // 1 if the heater is on, 0 otherwise
    output aircon,      // 1 if the air conditioner is on, 0 otherwise
    output fan          // 1 if the fan is on, 0 otherwise
);

    assign heater = (mode == 1) && (too_cold == 1);
    assign aircon = (mode == 0) && (too_hot == 1);
    assign fan = (heater == 1) || (aircon == 1) || (fan_on == 1);

endmodule