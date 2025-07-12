module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P_block,  // Group propagate
    output wire        G_block   // Group generate
);
    // Per-bit propagate and generate signals
    wire [15:0] P = A ^ B;
    wire [15:0] G = A & B;

    // Define prefix operator on (G,P) pairs:
    // (G_kj, P_kj) = (G_km | (P_km & G_mj), P_km & P_mj)
    // where k > m > j; used for carry computation in prefix tree
    function automatic [1:0] prefix_op;
        input [1:0] left;  // {G,P}
        input [1:0] right; // {G,P}
        reg   G_out, P_out;
        begin
            G_out = left[1] | (left[0] & right[1]);
            P_out = left[0] & right[0];
            prefix_op = {G_out, P_out};
        end
    endfunction

    // Stage 0: initial (G,P) pairs per bit
    wire [1:0] gp [15:0]; // {G,P}
    genvar i;
    generate
        for(i=0; i<16; i=i+1) begin
            assign gp[i] = {G[i], P[i]};
        end
    endgenerate

    // Now compute prefix tree using Brent-Kung structure (4 levels for 16 bits)
    // Level 1: combine pairs with stride 1
    wire [1:0] gnpg_level1 [15:0];
    generate
        for(i=0; i<16; i=i+1) begin
            if(i == 0)
                assign gnpg_level1[i] = gp[i];
            else if(i % 2 == 1)
                assign gnpg_level1[i] = prefix_op(gp[i], gp[i-1]);
            else
                assign gnpg_level1[i] = gp[i];
        end
    endgenerate

    // Level 2: combine pairs with stride 2
    wire [1:0] gnpg_level2 [15:0];
    generate
        for(i=0; i<16; i=i+1) begin
            if(i < 2)
                assign gnpg_level2[i] = gnpg_level1[i];
            else if(i % 4 >= 2)
                assign gnpg_level2[i] = prefix_op(gnpg_level1[i], gnpg_level1[i-2]);
            else
                assign gnpg_level2[i] = gnpg_level1[i];
        end
    endgenerate

    // Level 3: combine pairs with stride 4
    wire [1:0] gnpg_level3 [15:0];
    generate
        for(i=0; i<16; i=i+1) begin
            if(i < 4)
                assign gnpg_level3[i] = gnpg_level2[i];
            else if(i % 8 >= 4)
                assign gnpg_level3[i] = prefix_op(gnpg_level2[i], gnpg_level2[i-4]);
            else
                assign gnpg_level3[i] = gnpg_level2[i];
        end
    endgenerate

    // Level 4: combine pairs with stride 8
    wire [1:0] gnpg_level4 [15:0];
    generate
        for(i=0; i<16; i=i+1) begin
            if(i < 8)
                assign gnpg_level4[i] = gnpg_level3[i];
            else
                assign gnpg_level4[i] = prefix_op(gnpg_level3[i], gnpg_level3[i-8]);
        end
    endgenerate

    // Generate carry signals C[0]..C[16]
    // C[0] = Cin
    wire [16:0] C;
    assign C[0] = Cin;

    // Carry for bit i+1 = gnpg of bit i combined with Cin
    // i.e. C[i+1] = G_i_j | (P_i_j & C[0]) = gnpg_level4[i].G | gnpg_level4[i].P & Cin
    generate
        for(i=0; i<16; i=i+1) begin
            assign C[i+1] = gnpg_level4[i][1] | (gnpg_level4[i][0] & Cin);
        end
    endgenerate

    // Sum bits
    assign S = P ^ C[15:0];

    // Carry-out is carry from the most significant bit
    assign Cout = C[16];

    // Compute block propagate = AND of all P bits
    assign P_block = &P;

    // Compute block generate = G from last prefix pair combined with Cin
    // G_block = gnpg_level4[15].G | (gnpg_level4[15].P & Cin)
    assign G_block = gnpg_level4[15][1] | (gnpg_level4[15][0] & Cin);
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map [32:1] inputs to zero-based internal vectors [31:0]
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

    // Outputs and control signals from lower and upper blocks
    wire [15:0] S_low;
    wire [15:0] S_high;
    wire C16;         // Carry-out from lower block
    wire P0, G0;      // Propagate and generate from lower block
    wire P1, G1;      // Propagate and generate from upper block

    // Instantiate lower 16-bit CLA block with Cin=0
    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P_block(P0),
        .G_block(G0)
    );

    // Carry-in for upper block is G0 | (P0 & Cin=0) = G0
    wire Cin_high = G0;

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

    // Map sums back to [32:1] output vector
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx + 1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx + 17] = S_high[idx];
        end
    endgenerate
endmodule