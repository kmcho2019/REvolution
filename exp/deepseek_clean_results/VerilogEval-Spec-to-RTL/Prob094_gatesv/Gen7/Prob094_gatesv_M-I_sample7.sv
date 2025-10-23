module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: Only compute bits [2:0], set MSB to 0
    assign out_both = {1'b0, in[2:0] & in[3:1]};

    // out_any: Only compute bits [3:1], set LSB to 0
    assign out_any = {in[3:1] | in[2:0], 1'b0};

    // out_different: Efficient wrap-around XOR
    assign out_different = in ^ {in[0], in[3:1]};

endmodule