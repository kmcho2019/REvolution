module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Circular left shift for out_both (neighbor to left)
    wire [3:0] left_shifted = {in[2:0], in[3]};
    
    // Circular right shift for out_any (neighbor to right)
    wire [3:0] right_shifted = {in[0], in[3:1]};

    // out_both: AND with left neighbor (ignore MSB)
    assign out_both = {1'b0, in[2:0] & left_shifted[2:0]};
    
    // out_any: OR with right neighbor (ignore LSB)
    assign out_any = {right_shifted[3:1] | in[3:1], 1'b0};
    
    // out_different: XOR with circular left shift
    assign out_different = in ^ left_shifted;

endmodule