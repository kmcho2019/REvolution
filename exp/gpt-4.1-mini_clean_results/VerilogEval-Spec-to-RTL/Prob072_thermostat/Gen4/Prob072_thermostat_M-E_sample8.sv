module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

wire heater_active, aircon_active;

// Encode the control signals based on mode and temperature conditions
assign heater_active = (mode == 1'b1) && (too_cold == 1'b1);
assign aircon_active = (mode == 1'b0) && (too_hot == 1'b1);

// Outputs
assign heater = heater_active;
assign aircon = aircon_active;
// Fan is on if heater or aircon is on or if fan_on is requested
assign fan = heater_active | aircon_active | fan_on;

endmodule