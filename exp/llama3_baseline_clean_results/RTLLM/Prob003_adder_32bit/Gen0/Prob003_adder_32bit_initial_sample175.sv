// Define a 1-bit full adder
module full_adder(A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;
    wire sum, carry;

    assign sum = A ^ B ^ Cin;
    assign carry = (A & B) | (A & Cin) | (B & Cin);
    assign S = sum;
    assign Cout = carry;
endmodule

// Define a 4-bit carry-lookahead adder
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire [3:0] G, P;
    wire C1, C2, C3;

    // Calculate generate and propagate signals
    assign G[0] = A[0] & B[0];
    assign P[0] = A[0] | B[0];
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];

    // Calculate carry signals
    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & C1);
    assign C3 = G[2] | (P[2] & C2);

    // Calculate sum signals
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ C1;
    assign S[2] = A[2] ^ B[2] ^ C2;
    assign S[3] = A[3] ^ B[3] ^ C3;

    // Calculate final carry-out
    assign Cout = G[3] | (P[3] & C3);
endmodule

// Define a 16-bit carry-lookahead adder
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [7:0] G, P;
    wire [3:0] C;

    wire [7:0] A_low, B_low, S_low;
    wire [7:0] A_high, B_high, S_high;

    assign A_low = A[7:0];
    assign B_low = B[7:0];
    assign A_high = A[15:8];
    assign B_high = B[15:8];

    cla_4bit cla_low(A_low, B_low, Cin, S_low, C[0]);
    cla_4bit cla_high1(A_high[7:4], B_high[7:4], C[0], S_high[7:4], C[1]);
    cla_4bit cla_high2(A_high[3:0], B_high[3:0], C[1], S_high[3:0], Cout);

    assign S[7:0] = S_low;
    assign S[15:8] = S_high;
endmodule

// Define a 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire C16;

    cla_16bit cla_low(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit cla_high(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule