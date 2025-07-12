module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

wire [1:0] active_device;
// active_device[1] = heater enable
// active_device[0] = aircon enable

assign active_device[1] = mode & too_cold;    // Heater active in heating mode when too cold
assign active_device[0] = (~mode) & too_hot; // Aircon active in cooling mode when too hot

assign heater = active_device[1];
assign aircon = active_device[0];
assign fan = (|active_device) | fan_on;

endmodule