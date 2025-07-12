module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // In heating mode, turn on the heater when it's too cold
    // No change, as this condition is already minimal and straightforward
    assign heater = mode & too_cold;
    
    // In cooling mode, turn on the air conditioner when it's too hot
    // No change, as this condition is also minimal and straightforward
    assign aircon = ~mode & too_hot;
    
    // Turn on the fan when the heater or air conditioner is on, or when the fan is requested
    // Consider using a single expression that combines all conditions for turning on the fan
    // The existing solution is already optimal for this condition, given the need to include fan_on
    assign fan = (heater | aircon) | fan_on;

    // Alternative approach to fan control (not necessarily an improvement but an exploration)
    // assign fan = mode ? (too_cold | fan_on) : (too_hot | fan_on);
    // However, this doesn't seem to offer significant simplification or improvement over the original logic.

endmodule