module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Internal wires for shifted inputs to aid synthesis optimization
    wire [98:0] in_left_shifted = in[99:1];  // in shifted left by 1 bit (neighbor to left)
    wire [98:0] in_right_shifted = in[98:0]; // in (lower bits), neighbor to right

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99] = 0 (no left neighbor)
    assign out_both[98:0] = in[98:0] & in_left_shifted;
    assign out_both[99] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0] = 0 (no right neighbor)
    assign out_any[99:1] = in[99:1] | in_right_shifted;
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i-1) mod 100]
    // Wrap-around handled by concatenation of in[0] with in[99:1]
    assign out_different = in ^ {in[0], in[99:1]};

endmodule