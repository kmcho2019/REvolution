module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       Gg,  // Group Generate
    output       Pg,  // Group Propagate
    output       Cout
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [4:0] C;

    assign C[0] = Cin;

    // Carry lookahead logic for 4 bits
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign S = P ^ C[3:0];
    assign Cout = C[4];

    // Group propagate and generate
    assign Pg = &P; // all propagate
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [3:0] Gg, Pg;  // group generate and propagate for 4-bit blocks
    wire [4:0] C;       // carry signals between 4-bit blocks

    assign C[0] = Cin;

    // Instantiate 4 blocks of 4-bit CLA
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : cla4_blocks
            cla_4bit cla4 (
                .A(A[4*i+3:4*i]),
                .B(B[4*i+3:4*i]),
                .Cin(C[i]),
                .S(S[4*i+3:4*i]),
                .Gg(Gg[i]),
                .Pg(Pg[i]),
                .Cout()
            );
        end
    endgenerate

    // Compute carries between 4-bit blocks using group generate/propagate
    // Carry-out of block i+1 is computed by carry-lookahead formula:
    assign C[1] = Gg[0] | (Pg[0] & C[0]);
    assign C[2] = Gg[1] | (Pg[1] & Gg[0]) | (Pg[1] & Pg[0] & C[0]);
    assign C[3] = Gg[2] | (Pg[2] & Gg[1]) | (Pg[2] & Pg[1] & Gg[0]) | (Pg[2] & Pg[1] & Pg[0] & C[0]);
    assign C[4] = Gg[3] | (Pg[3] & Gg[2]) | (Pg[3] & Pg[2] & Gg[1]) | (Pg[3] & Pg[2] & Pg[1] & Gg[0]) | (Pg[3] & Pg[2] & Pg[1] & Pg[0] & C[0]);

    assign Cout = C[4];
endmodule

module adder_32bit(
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] S,
    output        C32
);
    wire C16;

    cla_16bit cla_lower (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );

    cla_16bit cla_upper (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule