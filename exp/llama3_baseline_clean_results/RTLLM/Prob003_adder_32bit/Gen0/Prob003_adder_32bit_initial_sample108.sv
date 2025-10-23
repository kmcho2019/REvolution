// Define a 1-bit full adder
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

// Define a 16-bit carry-lookahead adder (CLA) block
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire [15:1] G; // Generate
    wire [15:1] P; // Propagate
    wire [15:1] C; // Carry

    // Calculate Generate and Propagate bits
    genvar i;
    generate
        for (i = 1; i <= 16; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate

    // Calculate Carry bits using the CLA formula
    assign C[1] = Cin;
    generate
        for (i = 2; i <= 16; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Calculate Sum bits
    generate
        for (i = 1; i <= 16; i++) begin
            full_adder fa(
                .A(A[i]),
                .B(B[i]),
                .Cin(C[i]),
                .S(S[i]),
                .Cout()
            );
        end
    endgenerate

    assign Cout = C[16];
endmodule

// Define the top module: 32-bit carry-lookahead adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire Cout_16;

    cla_16bit cla1(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(Cout_16)
    );

    cla_16bit cla2(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(Cout_16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule