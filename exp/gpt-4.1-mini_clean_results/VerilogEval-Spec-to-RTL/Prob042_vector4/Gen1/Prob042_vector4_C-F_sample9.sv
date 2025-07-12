module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Sign-extend the 8-bit input 'in' to 32 bits by replicating the sign bit (in[7]) 24 times
    // followed by the original 8-bit input. This preserves the signed value in 32-bit form.
    assign out = { {24{in[7]}}, in };
endmodule