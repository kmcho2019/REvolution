module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// 2-bit vector: bit0 = ringer, bit1 = motor
wire [1:0] sel = vibrate_mode ? 2'b10 : 2'b01;

assign {motor, ringer} = ring ? sel : 2'b00;

endmodule