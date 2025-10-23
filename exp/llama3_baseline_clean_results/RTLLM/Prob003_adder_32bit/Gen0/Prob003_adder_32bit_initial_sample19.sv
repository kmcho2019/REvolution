// Define a module for 1-bit full adder
module full_adder(
    input A, 
    input B, 
    input Cin, 
    output S, 
    output Cout
);
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule

// Define a module for 16-bit carry-lookahead adder
module cla_16bit(
    input [16:1] A, 
    input [16:1] B, 
    input Cin, 
    output [16:1] S, 
    output Cout
);
    // Generate carry bits
    wire [16:1] G;
    wire [16:1] P;
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    generate
        for (genvar i = 2; i <= 16; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate

    // Calculate sum bits
    assign S[1] = A[1] ^ B[1] ^ Cin;
    wire [15:1] C;
    assign C[1] = (A[1] & B[1]) | (A[1] & Cin) | (B[1] & Cin);
    generate
        for (genvar i = 2; i <= 16; i++) begin
            assign S[i] = A[i] ^ B[i] ^ C[i-1];
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate
    assign Cout = C[16];
endmodule

// Define a module for 32-bit carry-lookahead adder
module adder_32bit(
    input [32:1] A, 
    input [32:1] B, 
    output [32:1] S, 
    output C32
);
    wire C16;
    cla_16bit u1(
        .A(A[16:1]), 
        .B(B[16:1]), 
        .Cin(1'b0), 
        .S(S[16:1]), 
        .Cout(C16)
    );
    cla_16bit u2(
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16), 
        .S(S[32:17]), 
        .Cout(C32)
    );
endmodule