module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Simplified out_both logic using vector operations
    assign out_both = {1'b0, in[2:0]} & {in[3:1], 1'b0};

    // Simplified out_any logic using vector operations
    assign out_any = {in[3:0], 1'b0} | {1'b0, in[3:1]};

    // Simplified out_different logic using XOR operator
    assign out_different = in ^ {in[0], in[3:1]};

endmodule