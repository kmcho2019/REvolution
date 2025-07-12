module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: optimal implementation remains unchanged
    assign out_both = {1'b0, in[98:0] & in[99:1]};

    // out_any: optimal implementation remains unchanged
    assign out_any = {in[99:1] | in[98:0], 1'b0};

    // out_different: optimized wrap-around implementation
    wire [99:0] left_neighbor = {in[0], in[99:1]};
    assign out_different = in ^ left_neighbor;

endmodule