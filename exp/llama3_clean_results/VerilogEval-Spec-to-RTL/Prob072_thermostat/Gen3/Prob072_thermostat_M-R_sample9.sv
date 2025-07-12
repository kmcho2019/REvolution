module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

// Intermediate signals for clarity
wire heat_on;
wire cool_on;
wire fan_from_heater_or_cooler;

// Determine if the heater should be on
assign heat_on = mode & too_cold;

// Determine if the air conditioner should be on
assign cool_on = ~mode & too_hot;

// Determine if the fan should be on due to heater or air conditioner
assign fan_from_heater_or_cooler = heat_on | cool_on;

// Final fan control also considers the fan_on input
assign fan = fan_from_heater_or_cooler | fan_on;

// Assign outputs
assign heater = heat_on;
assign aircon = cool_on;

endmodule