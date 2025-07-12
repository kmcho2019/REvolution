module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Circular right shift for left neighbor operations
    wire [3:0] right_shifted = {in[0], in[3:1]};
    
    // Circular left shift for right neighbor operations
    wire [3:0] left_shifted = {in[2:0], in[3]};
    
    // out_both: AND with right-shifted version (left neighbor)
    assign out_both = in & right_shifted;
    
    // out_any: OR with left-shifted version (right neighbor)
    assign out_any = in | left_shifted;
    
    // out_different: XOR with right-shifted version (left neighbor with wrap-around)
    assign out_different = in ^ right_shifted;

endmodule