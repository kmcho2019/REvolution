module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Shift input left by 1 with zero padding on LSB for out_both neighbor to left
    wire [99:0] in_shift_left = {in[98:0], 1'b0};
    assign out_both = (in & in_shift_left) & ~(1'b1 << 99); // Clear MSB bit 99
    
    // Shift input right by 1 with zero padding on MSB for out_any neighbor to right
    wire [99:0] in_shift_right = {1'b0, in[99:1]};
    assign out_any = (in | in_shift_right) & ~(1'b1 << 0); // Clear LSB bit 0

    // Circular left shift by 1 for wrap-around neighbor to left
    wire [99:0] in_circ_left = {in[98:0], in[99]};
    assign out_different = in ^ in_circ_left;

endmodule