module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Level 1: 50 2-input gates for each operation
    wire [49:0] and_l1, or_l1, xor_l1;
    genvar i;
    generate
        for (i = 0; i < 50; i = i + 1) begin : LEVEL1
            assign and_l1[i] = in[2*i] & in[2*i+1];
            assign or_l1[i]  = in[2*i] | in[2*i+1];
            assign xor_l1[i] = in[2*i] ^ in[2*i+1];
        end
    endgenerate

    // Level 2: 25 2-input gates
    wire [24:0] and_l2, or_l2, xor_l2;
    genvar j;
    generate
        for (j = 0; j < 25; j = j + 1) begin : LEVEL2
            assign and_l2[j] = and_l1[2*j] & and_l1[2*j+1];
            assign or_l2[j]  = or_l1[2*j] | or_l1[2*j+1];
            assign xor_l2[j] = xor_l1[2*j] ^ xor_l1[2*j+1];
        end
    endgenerate

    // Level 3: 13 2-input gates (handling odd count)
    wire [12:0] and_l3, or_l3, xor_l3;
    genvar k;
    generate
        for (k = 0; k < 12; k = k + 1) begin : LEVEL3
            assign and_l3[k] = and_l2[2*k] & and_l2[2*k+1];
            assign or_l3[k]  = or_l2[2*k] | or_l2[2*k+1];
            assign xor_l3[k] = xor_l2[2*k] ^ xor_l2[2*k+1];
        end
        // Handle the last odd input
        assign and_l3[12] = and_l2[24];
        assign or_l3[12]  = or_l2[24];
        assign xor_l3[12] = xor_l2[24];
    endgenerate

    // Level 4: 7 2-input gates
    wire [6:0] and_l4, or_l4, xor_l4;
    genvar m;
    generate
        for (m = 0; m < 6; m = m + 1) begin : LEVEL4
            assign and_l4[m] = and_l3[2*m] & and_l3[2*m+1];
            assign or_l4[m]  = or_l3[2*m] | or_l3[2*m+1];
            assign xor_l4[m] = xor_l3[2*m] ^ xor_l3[2*m+1];
        end
        // Handle the last odd input
        assign and_l4[6] = and_l3[12];
        assign or_l4[6]  = or_l3[12];
        assign xor_l4[6] = xor_l3[12];
    endgenerate

    // Final reduction
    assign out_and = &and_l4;
    assign out_or  = |or_l4;
    assign out_xor = ^xor_l4;

endmodule