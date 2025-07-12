module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND/OR using reduction operators (unchanged)
    assign out_and = &in;
    assign out_or  = |in;

    // XOR tree implementation refactored
    // Level 1: 25 parallel 4-bit XORs
    wire [24:0] xor_l1;
    assign xor_l1[ 0] = ^in[ 3: 0];
    assign xor_l1[ 1] = ^in[ 7: 4];
    assign xor_l1[ 2] = ^in[11: 8];
    assign xor_l1[ 3] = ^in[15:12];
    assign xor_l1[ 4] = ^in[19:16];
    assign xor_l1[ 5] = ^in[23:20];
    assign xor_l1[ 6] = ^in[27:24];
    assign xor_l1[ 7] = ^in[31:28];
    assign xor_l1[ 8] = ^in[35:32];
    assign xor_l1[ 9] = ^in[39:36];
    assign xor_l1[10] = ^in[43:40];
    assign xor_l1[11] = ^in[47:44];
    assign xor_l1[12] = ^in[51:48];
    assign xor_l1[13] = ^in[55:52];
    assign xor_l1[14] = ^in[59:56];
    assign xor_l1[15] = ^in[63:60];
    assign xor_l1[16] = ^in[67:64];
    assign xor_l1[17] = ^in[71:68];
    assign xor_l1[18] = ^in[75:72];
    assign xor_l1[19] = ^in[79:76];
    assign xor_l1[20] = ^in[83:80];
    assign xor_l1[21] = ^in[87:84];
    assign xor_l1[22] = ^in[91:88];
    assign xor_l1[23] = ^in[95:92];
    assign xor_l1[24] = ^in[99:96];

    // Level 2: 5 parallel 5-bit XORs
    wire [4:0] xor_l2;
    assign xor_l2[0] = ^xor_l1[ 4: 0];
    assign xor_l2[1] = ^xor_l1[ 9: 5];
    assign xor_l2[2] = ^xor_l1[14:10];
    assign xor_l2[3] = ^xor_l1[19:15];
    assign xor_l2[4] = ^xor_l1[24:20];

    // Final XOR
    assign out_xor = ^xor_l2;

endmodule