module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[3] has no left neighbor, set to 0
    assign out_both = {1'b0, in[2:0] & in[3:1]};
    // out_any[0] has no right neighbor, set to 0
    assign out_any  = {in[3:1] | in[2:0], 1'b0};
    // wrap-around XOR for out_different
    assign out_different = in ^ {in[0], in[3:1]};

endmodule