module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Use assign statements with conditional operators to simplify the logic
    assign out_both = { {99{1'b0}}, in[98:0]} & in;
    assign out_any = in | {in[98:0], 1'b0};
    assign out_different = in ^ {in[0], in[99:1]};

endmodule