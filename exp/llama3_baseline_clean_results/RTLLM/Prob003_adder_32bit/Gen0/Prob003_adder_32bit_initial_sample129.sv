module adder_16bit(A, B, Cin, S, Cout);
    input [15:1] A, B;
    input Cin;
    output [15:1] S;
    output Cout;

    wire [15:1] G, P;
    wire [14:1] C;

    // Calculate G and P signals
    assign G = A & B;
    assign P = A | B;

    // Calculate carry signals
    assign C[1] = G[1] | (P[1] & Cin);
    assign S[1] = A[1] ^ B[1] ^ Cin;

    genvar i;
    generate
        for (i = 2; i <= 15; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
            assign S[i] = A[i] ^ B[i] ^ C[i-1];
        end
    endgenerate

    assign Cout = G[15] | (P[15] & C[14]);
endmodule

module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    wire C16;

    adder_16bit u1(.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S[16:1]), .Cout(C16));
    adder_16bit u2(.A(A[32:17]), .B(B[32:17]), .Cin(C16), .S(S[32:17]), .Cout(C32));
endmodule