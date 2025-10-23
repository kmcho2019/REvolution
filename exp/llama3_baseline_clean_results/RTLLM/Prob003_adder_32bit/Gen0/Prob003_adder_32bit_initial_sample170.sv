// Define the 16-bit CLA block
module cla_16bit(
    input [16:1] A,  // 16-bit input operand A
    input [16:1] B,  // 16-bit input operand B
    input Cin,       // Carry-in input
    output [16:1] S, // 16-bit output representing the sum of A and B
    output Cout       // Carry-out output
);

    // Declare internal signals for generate (G) and propagate (P) signals
    wire [16:1] G, P;
    
    // Generate the generate (G) and propagate (P) signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    for (genvar i = 2; i <= 16; i++) begin
        assign G[i] = (A[i] & B[i]) | (P[i-1] & G[i-1]);
        assign P[i] = A[i] ^ B[i];
    end
    
    // Declare internal signal for sum output
    wire [16:1] sum;
    
    // Generate the sum output
    assign sum[1] = A[1] ^ B[1] ^ Cin;
    for (genvar i = 2; i <= 16; i++) begin
        assign sum[i] = A[i] ^ B[i] ^ (P[i-1] & (Cin | G[i-1]));
    end
    
    // Assign the sum output to the output port S
    assign S = sum;
    
    // Generate the carry-out output
    assign Cout = G[16] | (P[16] & (Cin | G[15]));
endmodule

// Define the top-level 32-bit adder module
module adder_32bit(
    input [32:1] A,  // 32-bit input operand A
    input [32:1] B,  // 32-bit input operand B
    output [32:1] S, // 32-bit output representing the sum of A and B
    output C32       // Carry-out output
);

    // Instantiate two 16-bit CLA blocks
    wire C16;  // Carry-out of the first 16-bit block
    cla_16bit u1(
        .A(A[16:1]),  // First 16 bits of A
        .B(B[16:1]),  // First 16 bits of B
        .Cin(1'b0),   // Carry-in for the first block
        .S(S[16:1]),  // Sum output of the first block
        .Cout(C16)    // Carry-out of the first block
    );
    cla_16bit u2(
        .A(A[32:17]), // Second 16 bits of A
        .B(B[32:17]), // Second 16 bits of B
        .Cin(C16),    // Carry-in for the second block (carry-out of the first block)
        .S(S[32:17]), // Sum output of the second block
        .Cout(C32)    // Carry-out of the second block
    );
endmodule