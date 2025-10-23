module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] shifted_left;
    wire [99:0] shifted_right;

    assign shifted_left = {in[0], in[99:1]};
    assign shifted_right = {in[98:0], 1'b0};

    assign out_both = in & shifted_right;
    assign out_any = in | shifted_left;
    assign out_different = in ^ shifted_left;

endmodule