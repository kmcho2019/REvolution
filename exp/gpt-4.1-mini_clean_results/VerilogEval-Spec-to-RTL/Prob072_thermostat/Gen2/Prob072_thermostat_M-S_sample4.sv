module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

assign {heater, aircon} = (mode) ? (too_cold ? 2'b10 : 2'b00) : (too_hot ? 2'b01 : 2'b00);
assign fan = heater | aircon | fan_on;

endmodule