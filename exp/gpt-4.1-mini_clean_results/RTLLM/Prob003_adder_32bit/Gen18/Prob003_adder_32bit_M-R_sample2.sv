module cla_4bit(
    input  [3:0] G,
    input  [3:0] P,
    input        Cin,
    output [4:1] C
);
    // Compute carries within 4-bit block using CLA logic
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);
endmodule

module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] G = A & B;
    wire [15:0] P = A ^ B;

    // Group Generate and Propagate for 4-bit blocks
    wire [3:0] Gg; // Group generate
    wire [3:0] Pg; // Group propagate

    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : blk_group_gen
            assign Gg[i] = G[i*4+3] | (P[i*4+3] & G[i*4+2]) | (P[i*4+3] & P[i*4+2] & G[i*4+1]) | (P[i*4+3] & P[i*4+2] & P[i*4+1] & G[i*4]);
            assign Pg[i] = P[i*4+3] & P[i*4+2] & P[i*4+1] & P[i*4];
        end
    endgenerate

    // Carry signals between 4-bit blocks
    wire [4:1] C_block; // Carry into each 4-bit block plus one extra for carry out
    // Use cla_4bit to get carry signals between 4-bit blocks
    cla_4bit block_cla (
        .G(Gg),
        .P(Pg),
        .Cin(Cin),
        .C(C_block)
    );

    // Calculate internal carries inside each 4-bit block
    wire [4:1] C0, C1, C2, C3; // internal carry signals for each 4-bit block

    cla_4bit cla0 (
        .G(G[3:0]),
        .P(P[3:0]),
        .Cin(C_block[0]),
        .C(C0)
    );

    cla_4bit cla1 (
        .G(G[7:4]),
        .P(P[7:4]),
        .Cin(C_block[1]),
        .C(C1)
    );

    cla_4bit cla2 (
        .G(G[11:8]),
        .P(P[11:8]),
        .Cin(C_block[2]),
        .C(C2)
    );

    cla_4bit cla3 (
        .G(G[15:12]),
        .P(P[15:12]),
        .Cin(C_block[3]),
        .C(C3)
    );

    // Assign carry signals for sum computation (C_in for each bit)
    wire [15:0] C_internal;
    assign C_internal[0]  = Cin;
    assign C_internal[3:1]  = C0[3:1];
    assign C_internal[7:4]  = C1[3:0];
    assign C_internal[11:8] = C2[3:0];
    assign C_internal[15:12]= C3[3:0];

    // Sum calculation
    assign S = P ^ C_internal;

    // Carry out is carry out of highest 4-bit block
    assign Cout = C_block[4];
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