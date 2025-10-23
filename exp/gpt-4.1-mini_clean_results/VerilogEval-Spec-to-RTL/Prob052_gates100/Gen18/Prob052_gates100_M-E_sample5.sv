module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Number of input bits
    localparam N = 100;

    // Compute the next power-of-two size >= N for balanced tree
    function integer next_power_of_two(input integer num);
        integer val;
        begin
            val = 1;
            while (val < num) val = val << 1;
            next_power_of_two = val;
        end
    endfunction

    localparam P2 = next_power_of_two(N); // 128

    // Extend input vectors with identity elements for each operator:
    // AND identity = 1, OR identity = 0, XOR identity = 0
    wire [P2-1:0] in_and_pad = {{(P2-N){1'b1}}, in};
    wire [P2-1:0] in_or_pad  = {{(P2-N){1'b0}}, in};
    wire [P2-1:0] in_xor_pad = {{(P2-N){1'b0}}, in};

    // Define a parameterized reduction stage function for AND, OR, XOR
    // We'll create generate blocks to iteratively reduce size from P2 down to 1

    // Stage-wise signals for AND
    wire [P2/2-1:0] and_stage1;
    wire [P2/4-1:0] and_stage2;
    wire [P2/8-1:0] and_stage3;
    wire [P2/16-1:0] and_stage4;
    wire [P2/32-1:0] and_stage5;
    wire [P2/64-1:0] and_stage6;
    wire [P2/128-1:0] and_stage7; // Will be zero width since 128 is max

    // Stage-wise signals for OR
    wire [P2/2-1:0] or_stage1;
    wire [P2/4-1:0] or_stage2;
    wire [P2/8-1:0] or_stage3;
    wire [P2/16-1:0] or_stage4;
    wire [P2/32-1:0] or_stage5;
    wire [P2/64-1:0] or_stage6;

    // Stage-wise signals for XOR
    wire [P2/2-1:0] xor_stage1;
    wire [P2/4-1:0] xor_stage2;
    wire [P2/8-1:0] xor_stage3;
    wire [P2/16-1:0] xor_stage4;
    wire [P2/32-1:0] xor_stage5;
    wire [P2/64-1:0] xor_stage6;

    // Level 1: combine pairs from input
    genvar i;
    generate
        for (i = 0; i < P2/2; i = i +1) begin : stage1
            assign and_stage1[i] = in_and_pad[2*i] & in_and_pad[2*i+1];
            assign or_stage1[i]  = in_or_pad[2*i]  | in_or_pad[2*i+1];
            assign xor_stage1[i] = in_xor_pad[2*i] ^ in_xor_pad[2*i+1];
        end
    endgenerate

    // Level 2
    generate
        for (i = 0; i < P2/4; i = i +1) begin : stage2
            assign and_stage2[i] = and_stage1[2*i] & and_stage1[2*i+1];
            assign or_stage2[i]  = or_stage1[2*i]  | or_stage1[2*i+1];
            assign xor_stage2[i] = xor_stage1[2*i] ^ xor_stage1[2*i+1];
        end
    endgenerate

    // Level 3
    generate
        for (i = 0; i < P2/8; i = i +1) begin : stage3
            assign and_stage3[i] = and_stage2[2*i] & and_stage2[2*i+1];
            assign or_stage3[i]  = or_stage2[2*i]  | or_stage2[2*i+1];
            assign xor_stage3[i] = xor_stage2[2*i] ^ xor_stage2[2*i+1];
        end
    endgenerate

    // Level 4
    generate
        for (i = 0; i < P2/16; i = i +1) begin : stage4
            assign and_stage4[i] = and_stage3[2*i] & and_stage3[2*i+1];
            assign or_stage4[i]  = or_stage3[2*i]  | or_stage3[2*i+1];
            assign xor_stage4[i] = xor_stage3[2*i] ^ xor_stage3[2*i+1];
        end
    endgenerate

    // Level 5
    generate
        for (i = 0; i < P2/32; i = i +1) begin : stage5
            assign and_stage5[i] = and_stage4[2*i] & and_stage4[2*i+1];
            assign or_stage5[i]  = or_stage4[2*i]  | or_stage4[2*i+1];
            assign xor_stage5[i] = xor_stage4[2*i] ^ xor_stage4[2*i+1];
        end
    endgenerate

    // Level 6
    generate
        for (i = 0; i < P2/64; i = i +1) begin : stage6
            assign and_stage6[i] = and_stage5[2*i] & and_stage5[2*i+1];
            assign or_stage6[i]  = or_stage5[2*i]  | or_stage5[2*i+1];
            assign xor_stage6[i] = xor_stage5[2*i] ^ xor_stage5[2*i+1];
        end
    endgenerate

    // Level 7 (only for AND)
    // P2 = 128, so P2/128 = 1 element
    wire and_final;
    assign and_final = and_stage6[0] & and_stage6[1];

    // Final outputs
    // For AND: and_final from level 7
    // For OR, XOR: level 6 signals have size 2, so reduce one more step manually
    assign out_and = and_final;

    wire or_final = or_stage6[0] | or_stage6[1];
    wire xor_final = xor_stage6[0] ^ xor_stage6[1];

    assign out_or = or_final;
    assign out_xor = xor_final;

endmodule