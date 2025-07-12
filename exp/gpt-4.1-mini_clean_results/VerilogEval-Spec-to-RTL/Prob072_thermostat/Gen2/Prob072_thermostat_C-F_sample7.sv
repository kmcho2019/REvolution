module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

wire heating = mode & too_cold;
wire cooling = (~mode) & too_hot;

assign heater = heating;
assign aircon = cooling;
assign fan    = heating | cooling | fan_on;

endmodule