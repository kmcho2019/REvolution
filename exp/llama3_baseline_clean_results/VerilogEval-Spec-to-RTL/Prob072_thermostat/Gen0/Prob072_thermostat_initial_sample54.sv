module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // In heating mode, turn the heater on when it's too cold, and turn the fan on when the heater is on or fan_on is active
    assign heater = mode && too_cold;
    assign aircon = 0; // Air conditioner is not used in heating mode

    // In cooling mode, turn the air conditioner on when it's too hot, and turn the fan on when the air conditioner is on or fan_on is active
    assign aircon = ~mode && too_hot;
    assign heater = 0; // Heater is not used in cooling mode

    // Turn the fan on when the heater is on, the air conditioner is on, or fan_on is active
    assign fan = (mode && too_cold) || (~mode && too_hot) || fan_on;

endmodule