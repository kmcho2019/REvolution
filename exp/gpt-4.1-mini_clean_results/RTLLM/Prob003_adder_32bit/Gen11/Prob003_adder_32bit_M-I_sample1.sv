module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P_block,  // Group propagate
    output wire        G_block   // Group generate
);
    // Per-bit propagate and generate
    wire [15:0] P = A ^ B;
    wire [15:0] G = A & B;

    // Define prefix node type
    typedef struct packed {
        logic p;  // propagate
        logic g;  // generate
    } pg_t;

    // Initial nodes per bit
    pg_t nodes [0:15];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : init_nodes
            assign nodes[i].p = P[i];
            assign nodes[i].g = G[i];
        end
    endgenerate

    // Prefix function: combine two nodes
    function automatic pg_t prefix_op(pg_t left, pg_t right);
        pg_t result;
        begin
            result.g = right.g | (right.p & left.g);
            result.p = right.p & left.p;
            prefix_op = result;
        end
    endfunction

    // Balanced prefix network: Brent-Kung style for 16 bits
    // Stage 1: combine pairs (distance 1)
    pg_t stage1[0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : s1_init
            if (i == 0) assign stage1[i] = nodes[i];
            else if (i % 2 == 1) assign stage1[i] = prefix_op(nodes[i-1], nodes[i]);
            else assign stage1[i] = nodes[i];
        end
    endgenerate

    // Stage 2: combine pairs (distance 2)
    pg_t stage2[0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : s2
            if (i < 2) assign stage2[i] = stage1[i];
            else if (i % 4 >= 2) assign stage2[i] = prefix_op(stage1[i-2], stage1[i]);
            else assign stage2[i] = stage1[i];
        end
    endgenerate

    // Stage 3: combine pairs (distance 4)
    pg_t stage3[0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : s3
            if (i < 4) assign stage3[i] = stage2[i];
            else if (i % 8 >= 4) assign stage3[i] = prefix_op(stage2[i-4], stage2[i]);
            else assign stage3[i] = stage2[i];
        end
    endgenerate

    // Stage 4: combine pairs (distance 8)
    pg_t stage4[0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : s4
            if (i < 8) assign stage4[i] = stage3[i];
            else assign stage4[i] = prefix_op(stage3[i-8], stage3[i]);
        end
    endgenerate

    // Compute carry-in for each bit:
    // c[0] = Cin (external input)
    // c[i] = group generate of bits [0..i-1], i in 1..16
    wire [16:0] c;
    assign c[0] = Cin;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_assign
            if (i == 16) 
                assign c[i] = stage4[15].g | (stage4[15].p & Cin);
            else
                assign c[i] = stage4[i-1].g | (stage4[i-1].p & Cin);
        end
    endgenerate

    // Sum computation
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_assign
            assign S[i] = P[i] ^ c[i];
        end
    endgenerate

    assign Cout = c[16];

    // Compute block propagate and generate signals using balanced prefix on all bits
    // Block propagate = AND of all P[i] -> already in stage4[15].p
    assign P_block = stage4[15].p;

    // Block generate = final group generate including Cin
    // Block generate = G_block = stage4[15].g | (stage4[15].p & Cin)
    // But since Cin is an input carry, and for block generation to be independent of Cin,
    // we define block generate as G_block = combined generates of bits ignoring Cin:
    // So we just assign G_block = stage4[15].g
    assign G_block = stage4[15].g;
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map [32:1] input vectors to [31:0] internal vectors with zero-based indexing
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx + 1];
            assign B_int[idx] = B[idx + 1];
        end
    endgenerate

    // Split into lower and upper 16 bits
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Outputs from lower and upper blocks
    wire [15:0] S_low;
    wire [15:0] S_high;
    wire C16;         // Carry-out from lower block
    wire P0, G0;      // Propagate and generate from lower block
    wire P1, G1;      // Propagate and generate from upper block

    // Instantiate lower 16-bit CLA block with carry-in 0
    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P_block(P0),
        .G_block(G0)
    );

    // Compute carry-in for upper block using group propagate/generate of lower block
    // Cin of top-level adder is 0
    wire Cin_high = G0 | (P0 & 1'b0);

    // Instantiate upper 16-bit CLA block with carry-in from lower block
    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P_block(P1),
        .G_block(G1)
    );

    // Map internal sums back to [32:1] output vector
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx + 1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx + 17] = S_high[idx];
        end
    endgenerate
endmodule