module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Shared signal for bits 2 and 3 priority
    wire no_prev_bits_2 = ~(|in[2:0]);

    // Optimized priority encoding
    assign pos[0] = in[1] | (in[3] & no_prev_bits_2);
    assign pos[1] = in[2] | (in[3] & no_prev_bits_2);

    // All-zero case is implicitly handled as pos will be 0
endmodule