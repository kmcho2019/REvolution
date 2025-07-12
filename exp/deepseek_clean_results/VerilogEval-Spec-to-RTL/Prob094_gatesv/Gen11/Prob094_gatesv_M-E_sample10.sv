module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] left_shifted = {in[2:0], 1'b0};  // Left shift for out_both
    wire [3:0] right_shifted = {1'b0, in[3:1]}; // Right shift for out_any
    wire [3:0] circular_left = {in[2:0], in[3]}; // Circular left shift for out_different

    // out_both: AND with left-shifted version (mask MSB)
    assign out_both = (in & left_shifted) & 4'b0111;
    
    // out_any: OR with right-shifted version (mask LSB)
    assign out_any = (in | right_shifted) & 4'b1110;
    
    // out_different: XOR with circular left-shifted version
    assign out_different = in ^ circular_left;

endmodule