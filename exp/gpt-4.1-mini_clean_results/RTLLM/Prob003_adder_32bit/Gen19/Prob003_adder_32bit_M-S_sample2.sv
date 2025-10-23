module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] G, P;
    wire [3:0]  G_block, P_block;
    wire [4:0]  C; // Carry signals

    assign G = A & B;
    assign P = A ^ B;
    assign C[0] = Cin;

    // Compute group propagate and generate for each 4-bit block
    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : block_gp
            assign P_block[i] = &P[i*4 +: 4];
            assign G_block[i] = G[i*4 + 3] | (P[i*4 + 3] & G[i*4 + 2]) |
                                (P[i*4 + 3] & P[i*4 + 2] & G[i*4 + 1]) |
                                (P[i*4 + 3] & P[i*4 + 2] & P[i*4 + 1] & G[i*4]);
        end
    endgenerate

    // Carry between blocks
    assign C[1] = G_block[0] | (P_block[0] & C[0]);
    assign C[2] = G_block[1] | (P_block[1] & C[1]);
    assign C[3] = G_block[2] | (P_block[2] & C[2]);
    assign C[4] = G_block[3] | (P_block[3] & C[3]);
    assign Cout = C[4];

    // Carry inside each 4-bit block
    wire [15:0] C_internal;
    generate
        for(i=0; i<4; i=i+1) begin : bits
            wire c0 = C[i]; // carry-in for block
            assign C_internal[i*4 + 0] = c0;
            assign C_internal[i*4 + 1] = G[i*4 + 0] | (P[i*4 + 0] & c0);
            assign C_internal[i*4 + 2] = G[i*4 + 1] | (P[i*4 + 1] & C_internal[i*4 + 1]);
            assign C_internal[i*4 + 3] = G[i*4 + 2] | (P[i*4 + 2] & C_internal[i*4 + 2]);
        end
    endgenerate

    assign S = P ^ C_internal;
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