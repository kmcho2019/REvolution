module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*) begin
    // Initialize outputs to default values (off)
    heater = 0;
    aircon = 0;
    fan = 0;

    // Control heater and air conditioner based on mode and temperature conditions
    if (mode == 1) { // Heating mode
        if (too_cold == 1) {
            heater = 1;
        }
    } else { // Cooling mode
        if (too_hot == 1) {
            aircon = 1;
        }
    }

    // Turn on fan if heater or air conditioner is on, or if fan_on is asserted
    if (heater == 1 || aircon == 1 || fan_on == 1) {
        fan = 1;
    }
end

endmodule