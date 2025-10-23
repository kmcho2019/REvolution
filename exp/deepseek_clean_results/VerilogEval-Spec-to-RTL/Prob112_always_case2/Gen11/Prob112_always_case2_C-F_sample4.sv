module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Priority detection signals (active when no higher priority bit is set)
    wire no_prev_bits_0 = ~in[0];
    wire no_prev_bits_1 = ~(|in[1:0]);
    wire no_prev_bits_2 = ~(|in[2:0]);

    // Position encoding with explicit priority
    assign pos[0] = (in[1] & no_prev_bits_0) | 
                   (in[3] & no_prev_bits_2);
    
    assign pos[1] = (in[2] & no_prev_bits_1) | 
                   (in[3] & no_prev_bits_2);

    // All-zero case is implicitly handled as pos will be 0
endmodule