module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Binary tree reduction for AND operation
    wire [126:0] and_tree; // 127 nodes (7 levels)
    genvar i;
    generate
        // Level 0: Inputs
        for (i = 0; i < 100; i = i + 1) begin : AND_LEAF
            assign and_tree[i] = in[i];
        end
        // Fill remaining leaves with 1's (AND identity)
        for (i = 100; i < 128; i = i + 1) begin : AND_FILL
            assign and_tree[i] = 1'b1;
        end
        
        // Tree levels
        for (i = 128; i < 192; i = i + 1) begin : AND_L1
            assign and_tree[i] = and_tree[2*(i-128)] & and_tree[2*(i-128)+1];
        end
        for (i = 192; i < 224; i = i + 1) begin : AND_L2
            assign and_tree[i] = and_tree[2*(i-192)+128] & and_tree[2*(i-192)+129];
        end
        for (i = 224; i < 240; i = i + 1) begin : AND_L3
            assign and_tree[i] = and_tree[2*(i-224)+192] & and_tree[2*(i-224)+193];
        end
        for (i = 240; i < 248; i = i + 1) begin : AND_L4
            assign and_tree[i] = and_tree[2*(i-240)+224] & and_tree[2*(i-240)+225];
        end
        for (i = 248; i < 252; i = i + 1) begin : AND_L5
            assign and_tree[i] = and_tree[2*(i-248)+240] & and_tree[2*(i-248)+241];
        end
        for (i = 252; i < 254; i = i + 1) begin : AND_L6
            assign and_tree[i] = and_tree[2*(i-252)+248] & and_tree[2*(i-252)+249];
        end
        assign and_tree[254] = and_tree[252] & and_tree[253];
    endgenerate
    assign out_and = and_tree[254];

    // Binary tree reduction for OR operation
    wire [126:0] or_tree; // 127 nodes (7 levels)
    generate
        // Level 0: Inputs
        for (i = 0; i < 100; i = i + 1) begin : OR_LEAF
            assign or_tree[i] = in[i];
        end
        // Fill remaining leaves with 0's (OR identity)
        for (i = 100; i < 128; i = i + 1) begin : OR_FILL
            assign or_tree[i] = 1'b0;
        end
        
        // Tree levels
        for (i = 128; i < 192; i = i + 1) begin : OR_L1
            assign or_tree[i] = or_tree[2*(i-128)] | or_tree[2*(i-128)+1];
        end
        for (i = 192; i < 224; i = i + 1) begin : OR_L2
            assign or_tree[i] = or_tree[2*(i-192)+128] | or_tree[2*(i-192)+129];
        end
        for (i = 224; i < 240; i = i + 1) begin : OR_L3
            assign or_tree[i] = or_tree[2*(i-224)+192] | or_tree[2*(i-224)+193];
        end
        for (i = 240; i < 248; i = i + 1) begin : OR_L4
            assign or_tree[i] = or_tree[2*(i-240)+224] | or_tree[2*(i-240)+225];
        end
        for (i = 248; i < 252; i = i + 1) begin : OR_L5
            assign or_tree[i] = or_tree[2*(i-248)+240] | or_tree[2*(i-248)+241];
        end
        for (i = 252; i < 254; i = i + 1) begin : OR_L6
            assign or_tree[i] = or_tree[2*(i-252)+248] | or_tree[2*(i-252)+249];
        end
        assign or_tree[254] = or_tree[252] | or_tree[253];
    endgenerate
    assign out_or = or_tree[254];

    // XOR using reduction operator (most efficient)
    assign out_xor = ^in;

endmodule