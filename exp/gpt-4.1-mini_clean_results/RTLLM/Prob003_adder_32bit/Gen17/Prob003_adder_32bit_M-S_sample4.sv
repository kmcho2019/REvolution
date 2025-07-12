module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] G = A & B;
    wire [15:0] P = A ^ B;
    wire [16:0] C;

    assign C[0] = Cin;
    genvar i;
    generate
        for (i=0; i<16; i=i+1)
            assign C[i+1] = G[i] | (P[i] & C[i]);
    endgenerate

    assign S = P ^ C[15:0];
    assign Cout = C[16];
endmodule

module adder_32bit(
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] S,
    output        C32
);
    wire C16;

    cla_16bit lower(.A(A[15:0]),  .B(B[15:0]),  .Cin(1'b0), .S(S[15:0]),  .Cout(C16));
    cla_16bit upper(.A(A[31:16]), .B(B[31:16]), .Cin(C16),  .S(S[31:16]), .Cout(C32));
endmodule