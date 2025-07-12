module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Directly select the 4-bit group from the input vector
assign out = in[({sel[7:4], 4'd0} * 16 + sel[3:0] * 4 +: 4]);

endmodule