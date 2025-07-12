module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Shared signal for highest priority bits
    wire no_prev_bits_2 = ~(|in[2:0]);

    // Optimized position encoding
    assign pos[0] = in[1] | (in[3] & no_prev_bits_2);
    assign pos[1] = (in[2] & ~in[1] & ~in[0]) | (in[3] & no_prev_bits_2);

endmodule