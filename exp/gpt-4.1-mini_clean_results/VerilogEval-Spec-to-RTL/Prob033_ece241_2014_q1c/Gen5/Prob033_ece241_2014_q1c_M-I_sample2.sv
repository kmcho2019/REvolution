module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [7:0] p;   // propagate
    wire [7:0] g;   // generate
    wire [7:0] c;   // carries, c[0] is carry-in for bit 0 (assumed 0)

    assign p = a ^ b;
    assign g = a & b;

    // Stage 0 - initial generate/propagate
    wire [7:0] gnpg_level0;
    wire [7:0] pp_level0;
    assign gnpg_level0 = g;
    assign pp_level0 = p;

    // Stage 1: Combine pairs (distance 1)
    wire [7:1] gnpg_level1;
    wire [7:1] pp_level1;

    genvar i;

    generate
        for (i = 1; i <= 7; i = i + 1) begin : stage1
            assign gnpg_level1[i] = gnpg_level0[i] | (pp_level0[i] & gnpg_level0[i-1]);
            assign pp_level1[i]   = pp_level0[i] & pp_level0[i-1];
        end
    endgenerate

    // Stage 2: Combine pairs (distance 2)
    wire [7:2] gnpg_level2;
    wire [7:2] pp_level2;

    generate
        for (i = 2; i <= 7; i = i + 1) begin : stage2
            assign gnpg_level2[i] = gnpg_level1[i] | (pp_level1[i] & gnpg_level1[i-2]);
            assign pp_level2[i]   = pp_level1[i] & pp_level1[i-2];
        end
    endgenerate

    // Stage 3: Combine pairs (distance 4)
    wire [7:4] gnpg_level3;
    wire [7:4] pp_level3;

    generate
        for (i = 4; i <= 7; i = i + 1) begin : stage3
            assign gnpg_level3[i] = gnpg_level2[i] | (pp_level2[i] & gnpg_level2[i-4]);
            assign pp_level3[i]   = pp_level2[i] & pp_level2[i-4];
        end
    endgenerate

    // Compute carries c[0] = 0 as initial carry-in
    assign c[0] = 1'b0;
    assign c[1] = gnpg_level0[0] | (pp_level0[0] & c[0]);
    assign c[2] = gnpg_level1[1] | (pp_level1[1] & c[0]);
    assign c[3] = gnpg_level2[2] | (pp_level2[2] & c[0]);
    assign c[4] = gnpg_level3[4] | (pp_level3[4] & c[0]);
    assign c[5] = gnpg_level3[5] | (pp_level3[5] & c[1]);
    assign c[6] = gnpg_level3[6] | (pp_level3[6] & c[2]);
    assign c[7] = gnpg_level3[7] | (pp_level3[7] & c[3]);

    // sum bits
    assign s = p ^ c[7:0];

    // Overflow = carry_in_to_MSB ^ carry_out_of_MSB
    // carry_in_to_MSB = c[6], carry_out_of_MSB = c[7]
    assign overflow = c[6] ^ c[7];

endmodule