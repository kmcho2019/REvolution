module TopModule(
    input  [7:0] in,  // 8-bit input number
    output [31:0] out // 32-bit output number
);

assign out = { {24{in[7]}}, in }; // replicate the sign bit 24 times and concatenate with the input number

endmodule