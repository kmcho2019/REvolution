module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Compute out_both using vectorized AND operation
    assign out_both = {100{1'b0}} & ({in[99:0], 1'b0} & in);

    // Compute out_any using vectorized OR operation
    assign out_any = {1'b0, in[99:1]} | in;

    // Compute out_different using vectorized XOR operation with wrap-around
    assign out_different = in ^ {in[0], in[99:1]};

endmodule