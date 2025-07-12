module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Create shifted versions of input for neighbor bits
    wire [99:0] in_left;  // neighbor to the left: bit i+1 with wrap at MSB for out_different
    wire [99:0] in_right; // neighbor to the right: bit i-1, with 0 at bit 0 for out_any
    
    // For out_both: neighbor to left for bits 0 to 98; out_both[99] = 0
    // Define in_left shifted left by 1 bit with zero padding at LSB for out_both
    wire [99:0] in_left_both = {in[98:0], 1'b0};

    // For out_any: neighbor to right for bits 1 to 99; out_any[0] = 0
    // Define in_right shifted right by 1 bit with zero padding at MSB for out_any
    wire [99:0] in_right_any = {1'b0, in[99:1]};

    // For out_different: neighbor to left with wrap-around (circular)
    // Circular shift left by 1 bit (bit i neighbor is in[(i+1)%100])
    assign in_left = {in[98:0], in[99]};

    // Circular shift right by 1 bit (bit i neighbor is in[(i-1)%100])
    assign in_right = {in[0], in[99:1]};

    // out_both: bits = in & in_left_both; out_both[99] = 0
    // Because in_left_both[99] = 0, out_both[99] = 0 implicitly
    assign out_both = in & in_left_both;

    // out_any: bits = in | in_right_any; out_any[0] = 0 implicitly because in_right_any[0] = 0
    assign out_any = in | in_right_any;

    // out_different: bits = in ^ in_left (circular left neighbor)
    assign out_different = in ^ in_left;

endmodule