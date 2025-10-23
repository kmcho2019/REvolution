module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] G = A & B;
    wire [16:1] P = A ^ B;
    wire [16:0] C;
    
    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    assign Cout = C[16];
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit cla_lower (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    cla_16bit cla_upper (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule