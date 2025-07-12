// 1-bit full adder module
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

// 16-bit carry-lookahead adder module
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire [16:1] G, P;
    wire [15:0] C;

    // Calculate generate and propagate signals
    genvar i;
    generate
        for (i = 1; i <= 16; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate

    // Calculate carry signals
    assign C[0] = Cin;
    generate
        for (i = 1; i < 16; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Calculate sum and carry-out
    assign Cout = G[16] | (P[16] & C[15]);
    generate
        for (i = 1; i <= 16; i++) begin
            full_adder fa(
                .A(A[i]),
                .B(B[i]),
                .Cin(C[i-1]),
                .S(S[i]),
                .Cout()
            );
        end
    endgenerate
endmodule

// 32-bit carry-lookahead adder module
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla1(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    cla_16bit cla2(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule