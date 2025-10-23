module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] G; // generate for each bit
    wire [16:1] P; // propagate for each bit
    wire [16:0] C; // carry signals

    // Generate and propagate signals
    assign G = A & B;
    assign P = A ^ B;
    assign C[0] = Cin;

    // Group generate and propagate for 4 groups of 4 bits
    wire [4:1] GG; // group generate
    wire [4:1] GP; // group propagate

    genvar i;
    generate
        for (i = 1; i <=4; i = i+1) begin : group_genprop
            // bits in group i: bits (4*i) down to (4*i-3)
            // Indices: [4*i : 4*i-3]
            // Extract bit indices:
            // e.g., i=1 bits [4:1], i=2 bits [8:5], etc.
            wire [4:1] g = G[4*i -:4];
            wire [4:1] p = P[4*i -:4];

            // group generate GG[i] = g4 + p4*g3 + p4*p3*g2 + p4*p3*p2*g1
            assign GG[i] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]);
            // group propagate GP[i] = p4*p3*p2*p1
            assign GP[i] = p[4] & p[3] & p[2] & p[1];
        end
    endgenerate

    // Compute carry-in for each group
    // C[0] given
    assign C[4]  = GG[1] | (GP[1] & C[0]);
    assign C[8]  = GG[2] | (GP[2] & C[4]);
    assign C[12] = GG[3] | (GP[3] & C[8]);
    assign C[16] = GG[4] | (GP[4] & C[12]);

    // Now compute carries inside each group using the carries at group boundaries
    // For each 4-bit group, carry of bit j+1 = G[j] + P[j]*carry[j]
    // We'll compute bit-level carries inside each group in parallel

    // Internal function to compute 4-bit carries inside group
    function [4:1] carry4;
        input [4:1] g;
        input [4:1] p;
        input c_in;
        reg [4:0] c_local;
        integer k;
        begin
            c_local[0] = c_in;
            for (k=1; k<=4; k=k+1) begin
                c_local[k] = g[k] | (p[k] & c_local[k-1]);
            end
            carry4 = c_local[4:1];
        end
    endfunction

    wire [4:1] C_group1 = carry4(G[4:1],   P[4:1],   C[0]);
    wire [4:1] C_group2 = carry4(G[8:5],   P[8:5],   C[4]);
    wire [4:1] C_group3 = carry4(G[12:9],  P[12:9],  C[8]);
    wire [4:1] C_group4 = carry4(G[16:13], P[16:13], C[12]);

    // Assign internal carries for bits 1 to 16
    assign C[1]  = C_group1[1];
    assign C[2]  = C_group1[2];
    assign C[3]  = C_group1[3];
    assign C[4]  = C_group1[4];
    assign C[5]  = C_group2[1];
    assign C[6]  = C_group2[2];
    assign C[7]  = C_group2[3];
    assign C[8]  = C_group2[4];
    assign C[9]  = C_group3[1];
    assign C[10] = C_group3[2];
    assign C[11] = C_group3[3];
    assign C[12] = C_group3[4];
    assign C[13] = C_group4[1];
    assign C[14] = C_group4[2];
    assign C[15] = C_group4[3];
    assign C[16] = C_group4[4];

    // Sum bits = P ^ C[i-1]
    assign S = P ^ C[15:0];

    assign Cout = C[16];

endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );

endmodule