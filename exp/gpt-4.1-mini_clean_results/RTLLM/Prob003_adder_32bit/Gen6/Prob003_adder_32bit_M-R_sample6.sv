module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] G; // Generate signals
    wire [15:0] P; // Propagate signals
    wire [3:0]  GG; // Group generate (4 groups)
    wire [3:0]  GP; // Group propagate
    wire [4:0]  C; // Carry signals including Cin and Cout

    // Bitwise generate and propagate
    assign G = A & B;
    assign P = A ^ B;

    // Group generate and propagate for 4-bit blocks
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : grp_gen
            wire [3:0] g = G[i*4 +: 4];
            wire [3:0] p = P[i*4 +: 4];
            // Group propagate = AND of all propagates in the group
            assign GP[i] = &p;
            // Group generate = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0
            assign GG[i] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
        end
    endgenerate

    // Carry chain at group level
    assign C[0] = Cin;
    assign C[1] = GG[0] | (GP[0] & C[0]);
    assign C[2] = GG[1] | (GP[1] & C[1]);
    assign C[3] = GG[2] | (GP[2] & C[2]);
    assign C[4] = GG[3] | (GP[3] & C[3]);

    // Internal carries within each 4-bit group
    wire [15:0] c_internal;
    generate
        for (i=0; i<4; i=i+1) begin : carry_within_group
            wire c0 = C[i];
            wire [3:0] g = G[i*4 +: 4];
            wire [3:0] p = P[i*4 +: 4];
            // Compute carry signals inside group with carry lookahead logic
            assign c_internal[i*4 + 0] = c0;
            assign c_internal[i*4 + 1] = g[0] | (p[0] & c_internal[i*4 + 0]);
            assign c_internal[i*4 + 2] = g[1] | (p[1] & c_internal[i*4 + 1]);
            assign c_internal[i*4 + 3] = g[2] | (p[2] & c_internal[i*4 + 2]);
        end
    endgenerate

    // Sum bits
    assign S = P ^ c_internal;

    // Final carry out is carry out of last bit
    assign Cout = G[15] | (P[15] & c_internal[15]);

endmodule

module adder_32bit(
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] S,
    output        C32
);
    wire C16;

    cla_16bit cla_low (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );

    cla_16bit cla_high (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule