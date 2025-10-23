module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output wire heater,
    output wire aircon,
    output wire fan
);

    // Heater ON in heating mode when too cold
    assign heater = mode & too_cold;

    // Aircon ON in cooling mode when too hot
    assign aircon = (~mode) & too_hot;

    // Combine heater and aircon signals for fan control
    wire heating_or_cooling = heater | aircon;

    // Fan ON when heater or aircon ON, or fan_on requested
    assign fan = heating_or_cooling | fan_on;

endmodule