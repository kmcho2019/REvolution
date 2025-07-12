module TopModule (
    input [7:0] in,
    output [31:0] out
);
    // Sign-extend 8-bit input to 32-bit: replicate MSB 24 times + original 8 bits
    assign out = {{24{in[7]}}, in};
endmodule