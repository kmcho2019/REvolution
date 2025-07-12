// Define the module for the 16-bit CLA block
module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A;
    input [16:1] B;
    input Cin;
    output [16:1] S;
    output Cout;

    // Internal wires
    wire [16:1] P, G;
    wire [16:1] C;

    // Calculate propagate and generate signals
    assign P[1] = A[1] ^ B[1];
    assign G[1] = A[1] & B[1];

    // Generate carry signals for each bit position
    generate
        for (genvar i = 2; i <= 16; i++) begin
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Calculate carry signals using the carry-lookahead equations
    assign C[1] = Cin;
    generate
        for (genvar i = 2; i <= 16; i++) begin
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate

    // Calculate the sum signals
    assign S[1] = A[1] ^ B[1] ^ Cin;
    generate
        for (genvar i = 2; i <= 16; i++) begin
            assign S[i] = A[i] ^ B[i] ^ C[i-1];
        end
    endgenerate

    // Calculate the final carry-out
    assign Cout = G[16] | (P[16] & C[15]);
endmodule

// Define the top-level module for the 32-bit adder
module adder_32bit(A, B, S, C32);
    input [32:1] A;
    input [32:1] B;
    output [32:1] S;
    output C32;

    // Instantiate two 16-bit CLA blocks
    wire [16:1] S_low;
    wire [16:1] S_high;
    wire Cout_low;

    cla_16bit cla_low(
       .A(A[16:1]),
       .B(B[16:1]),
       .Cin(1'b0),
       .S(S_low),
       .Cout(Cout_low)
    );

    cla_16bit cla_high(
       .A(A[32:17]),
       .B(B[32:17]),
       .Cin(Cout_low),
       .S(S_high),
       .Cout(C32)
    );

    // Assign the final sum output
    assign S[16:1] = S_low;
    assign S[32:17] = S_high;
endmodule