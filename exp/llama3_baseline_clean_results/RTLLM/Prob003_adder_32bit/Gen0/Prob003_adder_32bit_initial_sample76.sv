// 1-bit full adder
module full_adder (
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule

// 16-bit carry-lookahead adder
module cla_16bit (
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire [16:1] G, P, C;

    // Compute G and P signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    for (genvar i = 2; i <= 16; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end

    // Compute carry-in signals
    assign C[1] = Cin;
    for (genvar i = 2; i <= 16; i++) begin
        assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
    end

    // Compute sum signals
    for (genvar i = 1; i <= 16; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i];
    end

    // Compute carry-out signal
    assign Cout = G[16] | (P[16] & C[16]);
endmodule

// 32-bit carry-lookahead adder
module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output Cout
);
    wire Cout_16;

    // First 16-bit CLA block
    cla_16bit u_cla_1 (
       .A(A[16:1]),
       .B(B[16:1]),
       .Cin(1'b0),
       .S(S[16:1]),
       .Cout(Cout_16)
    );

    // Second 16-bit CLA block
    cla_16bit u_cla_2 (
       .A(A[32:17]),
       .B(B[32:17]),
       .Cin(Cout_16),
       .S(S[32:17]),
       .Cout(Cout)
    );
endmodule