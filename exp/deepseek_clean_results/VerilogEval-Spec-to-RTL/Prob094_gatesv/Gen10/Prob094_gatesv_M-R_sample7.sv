module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[2:0]: current bit AND left neighbor
    assign out_both = {1'b0, in[2:0] & in[3:1]};
    
    // out_any[3:1]: current bit OR right neighbor
    assign out_any = {in[3:1] | in[2:0], 1'b0};
    
    // out_different: XOR with left neighbor (wrap-around)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule