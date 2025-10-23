module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    wire sign_bit = in[7];
    // If sign bit is 1, replicate 24 ones, else replicate 24 zeros, then concatenate with original 8 bits
    assign out = { {24{sign_bit ? 1'b1 : 1'b0}}, in };
endmodule