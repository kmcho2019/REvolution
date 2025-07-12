module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

assign heater = mode & too_cold;
assign aircon = (~mode) & too_hot;

wire active = heater | aircon;
assign fan = active | fan_on;

endmodule