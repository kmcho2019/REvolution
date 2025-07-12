module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       Cout,
    output       G_out,
    output       P_out
);
    wire [3:0] G = A & B;       // Generate
    wire [3:0] P = A ^ B;       // Propagate

    // Carry signals for bits [0..3]
    wire C1, C2, C3;
    
    // Group generate and propagate signals
    assign G_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_out = P[3] & P[2] & P[1] & P[0];

    // Carries for each bit
    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & C1);
    assign C3 = G[2] | (P[2] & C2);
    assign Cout = G[3] | (P[3] & C3);

    // Sum bits
    assign S[0] = P[0] ^ Cin;
    assign S[1] = P[1] ^ C1;
    assign S[2] = P[2] ^ C2;
    assign S[3] = P[3] ^ C3;
endmodule

module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    // Divide 16 bits into 4 blocks of 4 bits
    wire [3:0] S_block [3:0];
    wire       G_block [3:0];
    wire       P_block [3:0];
    wire       C_block [4:0];

    assign C_block[0] = Cin;

    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : block4
            cla_4bit cla4 (
                .A(A[4*i +: 4]),
                .B(B[4*i +: 4]),
                .Cin(C_block[i]),
                .S(S_block[i]),
                .Cout(),        // Unused here, internal carry is handled inside cla_4bit
                .G_out(G_block[i]),
                .P_out(P_block[i])
            );
            // Compute carry-in for next block
            assign C_block[i+1] = G_block[i] | (P_block[i] & C_block[i]);
        end
    endgenerate

    assign Cout = C_block[4];

    // Concatenate sum outputs from blocks
    assign S = {S_block[3], S_block[2], S_block[1], S_block[0]};
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