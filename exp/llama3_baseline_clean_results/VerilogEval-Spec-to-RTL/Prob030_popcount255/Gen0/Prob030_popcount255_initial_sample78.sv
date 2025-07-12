module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Stage 1: Divide into 8 groups of 32 bits (with 1 bit left over, handled separately)
    // Count '1's in each group
    wire [7:0] group_counts;
    assign group_counts[0] = {4{in[ 31:  0]}} + {4{in[ 31:  0]}} + {4{in[ 31:  0]}} + {4{in[ 31: 0]}};
    assign group_counts[1] = {4{in[ 63: 32]}} + {4{in[ 63: 32]}} + {4{in[ 63: 32]}} + {4{in[ 63: 32]}};
    assign group_counts[2] = {4{in[ 95: 64]}} + {4{in[ 95: 64]}} + {4{in[ 95: 64]}} + {4{in[ 95: 64]}};
    assign group_counts[3] = {4{in[127: 96]}} + {4{in[127: 96]}} + {4{in[127: 96]}} + {4{in[127: 96]}};
    assign group_counts[4] = {4{in[159:128]}} + {4{in[159:128]}} + {4{in[159:128]}} + {4{in[159:128]}};
    assign group_counts[5] = {4{in[191:160]}} + {4{in[191:160]}} + {4{in[191:160]}} + {4{in[191:160]}};
    assign group_counts[6] = {4{in[223:192]}} + {4{in[223:192]}} + {4{in[223:192]}} + {4{in[223:192]}};
    assign group_counts[7] = {4{in[254:224]}};
    
    // Stage 2: Sum the counts from each group to get the final population count
    assign out = group_counts[0] + group_counts[1] + group_counts[2] + group_counts[3] +
                 group_counts[4] + group_counts[5] + group_counts[6] + group_counts[7];

endmodule