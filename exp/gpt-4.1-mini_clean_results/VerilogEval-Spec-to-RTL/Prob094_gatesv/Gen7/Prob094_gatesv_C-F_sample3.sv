module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Explicit zero for bits with no valid neighbor to avoid unnecessary toggling
    assign out_both[3] = 1'b0;
    assign out_both[2:0] = in[2:0] & in[3:1];

    assign out_any[0] = 1'b0;
    assign out_any[3:1] = in[3:1] | in[2:0];

    // Wrap-around XOR for difference with left neighbor (mod 4)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule