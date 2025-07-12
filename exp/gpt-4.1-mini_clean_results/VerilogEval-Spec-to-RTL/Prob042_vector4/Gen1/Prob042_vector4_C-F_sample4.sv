module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Sign-extend the 8-bit input to 32 bits by replicating the sign bit (bit 7)
    // 24 times and concatenating it with the original input bits.
    assign out = { {24{in[7]}}, in };
endmodule