// 16-bit carry-lookahead adder block
module cla_16bit (
    input [16:1] A,
    input [16:1] B,
    input Cin, // carry-in signal
    output [16:1] S,
    output Cout // carry-out signal
);

    // compute generate and propagate signals
    wire [16:1] G;
    wire [16:1] P;
    assign G = A & B;
    assign P = A | B;

    // compute carry signals
    wire [16:1] C;
    assign C[1] = G[1] | (P[1] & Cin);
    generate
        for (genvar i = 2; i <= 16; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // compute sum signals
    assign S = A ^ B ^ C;
    assign Cout = C[16];

endmodule

// 32-bit carry-lookahead adder
module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    // instantiate two 16-bit blocks
    wire C16;
    cla_16bit u1 (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0), // carry-in for the first block is 0
        .S(S[16:1]),
        .Cout(C16)
    );

    cla_16bit u2 (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16), // connect carry-out of first block to carry-in of second block
        .S(S[32:17]),
        .Cout(C32)
    );

endmodule