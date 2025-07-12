module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [15:0] G, P;
    wire [14:0] C;

    // Calculate Generate (G) and Propagate (P) signals
    assign G[0] = A[0] & B[0];
    assign P[0] = A[0] | B[0];
    assign C[0] = Cin;
    assign S[0] = A[0] ^ B[0] ^ Cin;

    generate
        for (genvar i = 1; i < 15; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
            assign S[i] = A[i] ^ B[i] ^ C[i];
        end
    endgenerate

    assign Cout = G[14] | (P[14] & C[14]);
    assign S[15] = A[15] ^ B[15] ^ C[15];
    assign C[15] = G[15] | (P[15] & C[14]);
endmodule

module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire C16;

    cla_16bit cla1(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit cla2(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule