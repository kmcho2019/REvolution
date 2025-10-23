module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    // Per-bit propagate and generate
    wire [15:0] P = A ^ B;
    wire [15:0] G = A & B;

    // Group propagate and generate for 4-bit groups (4 groups)
    wire [3:0] P_group;
    wire [3:0] G_group;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : grp_p_g
            // group propagate = P3 & P2 & P1 & P0 of the group
            assign P_group[i] = P[i*4+3] & P[i*4+2] & P[i*4+1] & P[i*4];
            // group generate = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0)
            assign G_group[i] = G[i*4+3] | (P[i*4+3] & G[i*4+2]) | (P[i*4+3] & P[i*4+2] & G[i*4+1]) | 
                                (P[i*4+3] & P[i*4+2] & P[i*4+1] & G[i*4]);
        end
    endgenerate

    // Carry signals for groups C0 to C4 (C0 = Cin)
    wire [4:0] C_group;
    assign C_group[0] = Cin;

    // Carry-lookahead for groups
    // C1 = G0_group + P0_group * C0
    // C2 = G1_group + P1_group * C1
    // ...
    assign C_group[1] = G_group[0] | (P_group[0] & C_group[0]);
    assign C_group[2] = G_group[1] | (P_group[1] & C_group[1]);
    assign C_group[3] = G_group[2] | (P_group[2] & C_group[2]);
    assign C_group[4] = G_group[3] | (P_group[3] & C_group[3]);

    // Now compute carries inside each 4-bit group
    wire [15:0] C; // Carry into each bit, C[0] = Cin
    assign C[0] = Cin;

    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_carry_gen
            // First bit in group
            if (i == 0) begin
                assign C[1] = G[0] | (P[0] & C[0]);
                assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
                assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
                assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0])
                              | (P[3] & P[2] & P[1] & P[0] & C[0]);
            end else begin
                // For groups 1..3, base carry-in is C_group[i]
                integer base = i*4;
                assign C[base+1] = G[base] | (P[base] & C_group[i]);
                assign C[base+2] = G[base+1] | (P[base+1] & G[base]) | (P[base+1] & P[base] & C_group[i]);
                assign C[base+3] = G[base+2] | (P[base+2] & G[base+1]) | (P[base+2] & P[base+1] & G[base])
                                  | (P[base+2] & P[base+1] & P[base] & C_group[i]);
                assign C[base+4] = G[base+3] | (P[base+3] & G[base+2]) | (P[base+3] & P[base+2] & G[base+1])
                                  | (P[base+3] & P[base+2] & P[base+1] & G[base])
                                  | (P[base+3] & P[base+2] & P[base+1] & P[base] & C_group[i]);
            end
        end
    endgenerate

    // Sum bits
    assign S = P ^ C[15:0];

    // Carry-out is carry after last bit (C[16])
    assign Cout = C_group[4];
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map inputs from [32:1] to [31:0]
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split inputs into lower and upper 16 bits
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;

    // Lower 16-bit CLA block with Cin=0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16)
    );

    // Upper 16-bit CLA block with Cin=C16
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(C16),
        .S(S_high),
        .Cout(C32)
    );

    // Map sum output back to [32:1]
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule