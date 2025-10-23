module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Create rotated versions of 'in' vector to represent neighbor bits
    wire [99:0] in_left;   // neighbor to the left (i.e., bit i+1, with wrap for out_different)
    wire [99:0] in_right;  // neighbor to the right (i.e., bit i-1)

    // Rotate left by 1: neighbor to the left for wrap-around (for out_different)
    assign in_left  = {in[98:0], in[99]};
    // Rotate left by 1: neighbor to the left for out_both (no wrap, but out_both[99] = 0)
    // We'll use this same vector but mask out bit 99 later.
    // Rotate right by 1: neighbor to the right for out_any (no wrap, but out_any[0] = 0)
    assign in_right = {in[0], in[99:1]};

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99] = 0
    // in_left corresponds to i+1 for i=0..98 except for last bit; so mask bit 99 out.
    assign out_both = (in & in_left) & {99{1'b1}, 1'b0};

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0] = 0
    // in_right corresponds to i-1 for i=1..99, with wrap-around at bit 0 to bit 99.
    // We mask bit 0 to zero explicitly.
    assign out_any = (in | in_right) & {1'b0, {99{1'b1}}};

    // out_different[i] = in[i] ^ in[(i+1)%100] (wrap around)
    assign out_different = in ^ in_left;

endmodule