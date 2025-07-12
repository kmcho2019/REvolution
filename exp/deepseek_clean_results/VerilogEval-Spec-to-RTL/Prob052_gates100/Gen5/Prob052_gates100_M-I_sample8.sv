module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Level 1: Process 64 groups (pad with 1's for AND, 0's for OR)
    wire [63:0] l1_and, l1_or, l1_xor;
    assign l1_and[63:0] = { &in[99:96], &in[95:92], &in[91:88], &in[87:84],
                           &in[83:80], &in[79:76], &in[75:72], &in[71:68],
                           &in[67:64], &in[63:60], &in[59:56], &in[55:52],
                           &in[51:48], &in[47:44], &in[43:40], &in[39:36],
                           &in[35:32], &in[31:28], &in[27:24], &in[23:20],
                           &in[19:16], &in[15:12], &in[11:8],  &in[7:4],
                           &in[3:0],   {39{1'b1}} }; // Pad with 1's for AND
    
    assign l1_or[63:0] = { |in[99:96], |in[95:92], |in[91:88], |in[87:84],
                          |in[83:80], |in[79:76], |in[75:72], |in[71:68],
                          |in[67:64], |in[63:60], |in[59:56], |in[55:52],
                          |in[51:48], |in[47:44], |in[43:40], |in[39:36],
                          |in[35:32], |in[31:28], |in[27:24], |in[23:20],
                          |in[19:16], |in[15:12], |in[11:8],  |in[7:4],
                          |in[3:0],   {39{1'b0}} }; // Pad with 0's for OR
    
    assign l1_xor[63:0] = { ^in[99:96], ^in[95:92], ^in[91:88], ^in[87:84],
                           ^in[83:80], ^in[79:76], ^in[75:72], ^in[71:68],
                           ^in[67:64], ^in[63:60], ^in[59:56], ^in[55:52],
                           ^in[51:48], ^in[47:44], ^in[43:40], ^in[39:36],
                           ^in[35:32], ^in[31:28], ^in[27:24], ^in[23:20],
                           ^in[19:16], ^in[15:12], ^in[11:8],  ^in[7:4],
                           ^in[3:0],   {39{1'b0}} }; // Pad with 0's for XOR

    // Level 2-6: Binary tree reduction
    wire [31:0] l2_and = { &l1_and[63:62], &l1_and[61:60], &l1_and[59:58], &l1_and[57:56],
                          &l1_and[55:54], &l1_and[53:52], &l1_and[51:50], &l1_and[49:48],
                          &l1_and[47:46], &l1_and[45:44], &l1_and[43:42], &l1_and[41:40],
                          &l1_and[39:38], &l1_and[37:36], &l1_and[35:34], &l1_and[33:32],
                          &l1_and[31:30], &l1_and[29:28], &l1_and[27:26], &l1_and[25:24],
                          &l1_and[23:22], &l1_and[21:20], &l1_and[19:18], &l1_and[17:16],
                          &l1_and[15:14], &l1_and[13:12], &l1_and[11:10], &l1_and[9:8],
                          &l1_and[7:6], &l1_and[5:4], &l1_and[3:2], &l1_and[1:0] };
    
    wire [31:0] l2_or = { |l1_or[63:62], |l1_or[61:60], |l1_or[59:58], |l1_or[57:56],
                         |l1_or[55:54], |l1_or[53:52], |l1_or[51:50], |l1_or[49:48],
                         |l1_or[47:46], |l1_or[45:44], |l1_or[43:42], |l1_or[41:40],
                         |l1_or[39:38], |l1_or[37:36], |l1_or[35:34], |l1_or[33:32],
                         |l1_or[31:30], |l1_or[29:28], |l1_or[27:26], |l1_or[25:24],
                         |l1_or[23:22], |l1_or[21:20], |l1_or[19:18], |l1_or[17:16],
                         |l1_or[15:14], |l1_or[13:12], |l1_or[11:10], |l1_or[9:8],
                         |l1_or[7:6], |l1_or[5:4], |l1_or[3:2], |l1_or[1:0] };
    
    wire [31:0] l2_xor = { ^l1_xor[63:62], ^l1_xor[61:60], ^l1_xor[59:58], ^l1_xor[57:56],
                          ^l1_xor[55:54], ^l1_xor[53:52], ^l1_xor[51:50], ^l1_xor[49:48],
                          ^l1_xor[47:46], ^l1_xor[45:44], ^l1_xor[43:42], ^l1_xor[41:40],
                          ^l1_xor[39:38], ^l1_xor[37:36], ^l1_xor[35:34], ^l1_xor[33:32],
                          ^l1_xor[31:30], ^l1_xor[29:28], ^l1_xor[27:26], ^l1_xor[25:24],
                          ^l1_xor[23:22], ^l1_xor[21:20], ^l1_xor[19:18], ^l1_xor[17:16],
                          ^l1_xor[15:14], ^l1_xor[13:12], ^l1_xor[11:10], ^l1_xor[9:8],
                          ^l1_xor[7:6], ^l1_xor[5:4], ^l1_xor[3:2], ^l1_xor[1:0] };

    // Continue reduction through levels 3-6 similarly
    wire [15:0] l3_and = { &l2_and[31:30], &l2_and[29:28], &l2_and[27:26], &l2_and[25:24],
                          &l2_and[23:22], &l2_and[21:20], &l2_and[19:18], &l2_and[17:16],
                          &l2_and[15:14], &l2_and[13:12], &l2_and[11:10], &l2_and[9:8],
                          &l2_and[7:6], &l2_and[5:4], &l2_and[3:2], &l2_and[1:0] };
    
    wire [7:0] l4_and = { &l3_and[15:14], &l3_and[13:12], &l3_and[11:10], &l3_and[9:8],
                         &l3_and[7:6], &l3_and[5:4], &l3_and[3:2], &l3_and[1:0] };
    
    wire [3:0] l5_and = { &l4_and[7:6], &l4_and[5:4], &l4_and[3:2], &l4_and[1:0] };
    
    wire [1:0] l6_and = { &l5_and[3:2], &l5_and[1:0] };
    
    // Final output assignments
    assign out_and = &l6_and;
    assign out_or = |l2_or; // OR converges faster due to nature of operation
    assign out_xor = ^l1_xor; // XOR can use parallel prefix for final reduction

endmodule