module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Left-shifted version for out_both (neighbor to left)
    wire [3:0] left_shifted = {in[2:0], 1'b0};
    
    // Right-shifted version for out_any (neighbor to right)
    wire [3:0] right_shifted = {1'b0, in[3:1]};
    
    // Circular left-shifted version for out_different
    wire [3:0] circular_shifted = {in[2:0], in[3]};
    
    assign out_both = in & left_shifted;
    assign out_any = in | right_shifted;
    assign out_different = in ^ circular_shifted;

endmodule