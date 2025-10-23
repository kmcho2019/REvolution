module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND tree implementation
    wire [24:0] and_l1;
    wire [5:0] and_l2;
    wire [1:0] and_l3;
    
    // Level 1: 25 groups of 4 bits
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : and_tree_l1
            assign and_l1[i] = &in[(i*4)+3 : i*4];
        end
    endgenerate
    
    // Level 2: 6 groups of 4 bits + 1 extra
    for (i = 0; i < 6; i = i + 1) begin : and_tree_l2
        assign and_l2[i] = &and_l1[(i*4)+3 : i*4];
    end
    assign and_l2[6] = &and_l1[24];
    
    // Level 3: 2 groups of 3 bits
    assign and_l3[0] = &and_l2[2:0];
    assign and_l3[1] = &and_l2[5:3];
    
    // Final AND
    assign out_and = and_l3[0] & and_l3[1] & and_l2[6];

    // OR tree implementation (similar structure)
    wire [24:0] or_l1;
    wire [5:0] or_l2;
    wire [1:0] or_l3;
    
    generate
        for (i = 0; i < 25; i = i + 1) begin : or_tree_l1
            assign or_l1[i] = |in[(i*4)+3 : i*4];
        end
    endgenerate
    
    for (i = 0; i < 6; i = i + 1) begin : or_tree_l2
        assign or_l2[i] = |or_l1[(i*4)+3 : i*4];
    end
    assign or_l2[6] = |or_l1[24];
    
    assign or_l3[0] = |or_l2[2:0];
    assign or_l3[1] = |or_l2[5:3];
    
    assign out_or = or_l3[0] | or_l3[1] | or_l2[6];

    // XOR tree implementation (parity calculation)
    wire [49:0] xor_l1;
    wire [24:0] xor_l2;
    wire [11:0] xor_l3;
    wire [5:0] xor_l4;
    wire [2:0] xor_l5;
    
    // Level 1: 50 pairs
    generate
        for (i = 0; i < 50; i = i + 1) begin : xor_tree_l1
            assign xor_l1[i] = in[i*2] ^ in[(i*2)+1];
        end
    endgenerate
    
    // Level 2: 25 pairs
    for (i = 0; i < 25; i = i + 1) begin : xor_tree_l2
        assign xor_l2[i] = xor_l1[i*2] ^ xor_l1[(i*2)+1];
    end
    
    // Level 3: 12 pairs + 1 extra
    for (i = 0; i < 12; i = i + 1) begin : xor_tree_l3
        assign xor_l3[i] = xor_l2[i*2] ^ xor_l2[(i*2)+1];
    end
    assign xor_l3[12] = xor_l2[24];
    
    // Level 4: 6 pairs
    for (i = 0; i < 6; i = i + 1) begin : xor_tree_l4
        assign xor_l4[i] = xor_l3[i*2] ^ xor_l3[(i*2)+1];
    end
    
    // Level 5: 3 pairs
    assign xor_l5[0] = xor_l4[0] ^ xor_l4[1];
    assign xor_l5[1] = xor_l4[2] ^ xor_l4[3];
    assign xor_l5[2] = xor_l4[4] ^ xor_l4[5];
    
    // Final XOR
    assign out_xor = xor_l5[0] ^ xor_l5[1] ^ xor_l5[2];

endmodule