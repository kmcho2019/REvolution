// Define the module for the 16-bit carry-lookahead adder block
module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A, B;
    input Cin;
    output [16:1] S;
    output Cout;

    // Declare the internal signals for the generate and propagate signals
    wire [16:1] G, P;

    // Generate and propagate signals for each bit position
    genvar i;
    generate
        for (i = 1; i <= 16; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate

    // Calculate the carry-out for each bit position using the generate and propagate signals
    wire [16:1] C;
    assign C[1] = Cin;
    generate
        for (i = 2; i <= 16; i++) begin
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate

    // Calculate the sum for each bit position using the input operands and the carry signals
    assign S[1] = A[1] ^ B[1] ^ Cin;
    generate
        for (i = 2; i <= 16; i++) begin
            assign S[i] = A[i] ^ B[i] ^ C[i-1];
        end
    endgenerate

    // The carry-out of the 16-bit block is the carry-out of the most significant bit
    assign Cout = G[16] | (P[16] & C[16]);
endmodule

// Define the top-level module for the 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    // Declare the internal signals for the carry-out of the first 16-bit block
    wire Cout_16;

    // Instantiate the first 16-bit CLA block for the least significant 16 bits
    cla_16bit cla_16bit_0(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(Cout_16)
    );

    // Instantiate the second 16-bit CLA block for the most significant 16 bits
    cla_16bit cla_16bit_1(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(Cout_16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule