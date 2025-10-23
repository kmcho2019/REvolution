module TopModule(
    input  [7:0] in,  // 8-bit input
    output [31:0] out  // 32-bit output
);

assign out = ({24{in[7]}}, in);  // replicate the sign bit 24 times and concatenate with the 8-bit number

endmodule