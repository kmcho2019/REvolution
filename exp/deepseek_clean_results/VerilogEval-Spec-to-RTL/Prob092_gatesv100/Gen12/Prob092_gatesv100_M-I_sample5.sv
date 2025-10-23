module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Edge cases
    assign out_both[99] = 1'b0;
    assign out_any[0] = 1'b0;

    // Combined bitwise operations for regular bits
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_any[99:1] = in[99:1] | in[98:0];

    // Wrap-around difference (already optimal)
    assign out_different = in ^ {in[0], in[99:1]};

endmodule