// 16-bit carry-lookahead adder block
module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin, // carry-in signal
    output [15:0] S,
    output Cout // carry-out signal
);

    // compute generate and propagate signals
    wire [15:0] G;
    wire [15:0] P;
    assign G = A & B;
    assign P = A | B;

    // compute carry signals
    wire [15:0] C;
    assign C[0] = G[0] | (P[0] & Cin);
    generate
        for (genvar i = 1; i < 16; i++) begin
            assign C[i] = G[i] | (P[i] & (C[i-1]));
        end
    endgenerate

    // compute sum signals
    assign S = A ^ B ^ C;
    assign Cout = C[15];

endmodule

// 32-bit carry-lookahead adder
module adder_32bit (
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);

    // instantiate two 16-bit blocks
    wire C16;
    cla_16bit u1 (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0), // carry-in for the first block is 0
        .S(S[15:0]),
        .Cout(C16)
    );

    cla_16bit u2 (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16), // connect carry-out of first block to carry-in of second block
        .S(S[31:16]),
        .Cout(C32)
    );

endmodule