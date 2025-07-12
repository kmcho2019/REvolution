// Module for a 16-bit carry-lookahead adder
module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A;
    input [16:1] B;
    input Cin;
    output [16:1] S;
    output Cout;

    wire [16:1] G, P;
    wire [16:0] C;

    // Calculate generate (G) and propagate (P) signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    for (genvar i = 2; i <= 16; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end

    // Calculate carry signals
    assign C[0] = Cin;
    for (genvar i = 1; i <= 16; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end

    // Calculate sum signals
    for (genvar i = 1; i <= 16; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end

    // Assign carry-out
    assign Cout = C[16];
endmodule

// Module for a 32-bit carry-lookahead adder using two 16-bit CLA blocks
module adder_32bit(A, B, S, C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    wire [16:1] S1, S2;
    wire Cout1;
    assign A1 = A[16:1];
    assign B1 = B[16:1];
    assign A2 = A[32:17];
    assign B2 = B[32:17];

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla1(A1, B1, 1'b0, S1, Cout1);
    cla_16bit cla2(A2, B2, Cout1, S2, C32);

    // Assign sum signals
    assign S[16:1] = S1;
    assign S[32:17] = S2;
endmodule