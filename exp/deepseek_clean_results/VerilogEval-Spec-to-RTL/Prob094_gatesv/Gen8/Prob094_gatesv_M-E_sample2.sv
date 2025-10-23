module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Circular right shift for left neighbor alignment
    wire [3:0] left_neighbor = {in[0], in[3:1]};
    
    // Circular left shift for right neighbor alignment
    wire [3:0] right_neighbor = {in[2:0], in[3]};
    
    // out_both: AND with left neighbor (ignore MSB result)
    assign out_both = in & left_neighbor;
    
    // out_any: OR with right neighbor (ignore LSB result)
    assign out_any = in | right_neighbor;
    
    // out_different: XOR with left neighbor (full circular)
    assign out_different = in ^ left_neighbor;

endmodule