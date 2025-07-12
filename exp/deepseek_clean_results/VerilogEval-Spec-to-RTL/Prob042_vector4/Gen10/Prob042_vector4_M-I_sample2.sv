module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Efficient sign-extension: replicate MSB (bit[7]) 24 times and concatenate with original 8 bits
    assign out = {{24{in[7]}}, in};
endmodule