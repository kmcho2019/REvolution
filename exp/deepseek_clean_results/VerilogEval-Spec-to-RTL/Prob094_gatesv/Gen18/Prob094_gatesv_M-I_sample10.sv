module TopModule (
    input [3:0] in,
    output [2:0] out_both,  // Only need bits 2:0
    output [3:1] out_any,   // Only need bits 3:1
    output [3:0] out_different
);

    // out_both: current bit AND left neighbor (bits 2:0 only)
    assign out_both = in[2:0] & in[3:1];
    
    // out_any: current bit OR right neighbor (bits 3:1 only)
    assign out_any = in[3:1] | in[2:0];
    
    // out_different: XOR with left neighbor (wrap-around)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule