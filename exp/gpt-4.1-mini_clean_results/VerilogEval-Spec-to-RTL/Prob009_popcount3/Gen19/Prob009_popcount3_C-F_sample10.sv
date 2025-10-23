module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Population count: sum the three input bits (each 1-bit)
    // Result fits in 2 bits, directly assign sum to output
    assign out = in[0] + in[1] + in[2];

endmodule