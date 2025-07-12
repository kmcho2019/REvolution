module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Direct assignment for out_both: current bit and the one to its left are both '1'
    assign out_both = {99'b0, in[99:1]} & in;

    // Direct assignment for out_any: current bit or the one to its right is '1'
    assign out_any = in | {in[98:0], 1'b0};

    // Direct assignment for out_different: current bit differs from the one to its left (with wrap-around)
    assign out_different = in ^ {in[0], in[99:1]};

endmodule