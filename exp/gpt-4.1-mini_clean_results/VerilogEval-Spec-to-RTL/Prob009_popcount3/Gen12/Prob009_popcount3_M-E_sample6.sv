module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    wire bit0_set = in[0];
    wire bit1_set = in[1];
    wire bit2_set = in[2];

    // Count how many bits are set using logic expressions
    // out[0] = parity of bits set (1 if odd number of bits set)
    assign out[0] = bit0_set ^ bit1_set ^ bit2_set;

    // out[1] = 1 if two or more bits are set
    assign out[1] = (bit0_set & bit1_set) | (bit1_set & bit2_set) | (bit0_set & bit2_set);
endmodule