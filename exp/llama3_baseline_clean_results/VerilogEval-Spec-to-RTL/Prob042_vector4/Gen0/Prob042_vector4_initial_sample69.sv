module TopModule(
    input [7:0] in,  // input 8-bit number
    output [31:0] out  // output 32-bit number
);

// Sign-extend the 8-bit input number to 32 bits
assign out = { {24{in[7]}}, in };  // replicate sign bit 24 times and concatenate with the input number

endmodule