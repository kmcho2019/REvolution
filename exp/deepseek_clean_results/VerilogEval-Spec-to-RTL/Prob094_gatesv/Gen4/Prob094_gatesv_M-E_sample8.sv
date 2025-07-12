module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Circular right shift for left neighbor comparison
    wire [3:0] shifted_right = {in[0], in[3:1]};
    
    // Circular left shift for right neighbor comparison
    wire [3:0] shifted_left = {in[2:0], in[3]};

    // out_both: AND with right-shifted (left neighbor)
    assign out_both = in & shifted_right;
    
    // out_any: OR with left-shifted (right neighbor)
    assign out_any = in | shifted_left;
    
    // out_different: XOR with right-shifted (left neighbor with wrap-around)
    assign out_different = in ^ shifted_right;

endmodule