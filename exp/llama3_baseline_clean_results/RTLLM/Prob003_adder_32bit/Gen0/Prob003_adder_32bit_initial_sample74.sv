// 16-bit carry-lookahead adder module
module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A, B;
    input Cin;
    output [16:1] S;
    output Cout;
    wire [16:1] G, P; // generate and propagate signals
    wire [15:1] C; // internal carry signals

    // generate generate and propagate signals
    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
        end
    endgenerate

    // calculate internal carry signals
    assign C[1] = G[1] | (P[1] & Cin);
    generate
        for (i = 2; i <= 15; i = i + 1) begin
            assign C[i] = G[i] | (P[i] & (G[i-1] | (P[i-1] & C[i-1])));
        end
    endgenerate

    // calculate sum bits
    generate
        for (i = 1; i <= 16; i = i + 1) begin
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    // calculate final carry-out
    assign Cout = G[16] | (P[16] & (G[15] | (P[15] & C[15])));

endmodule

// 32-bit carry-lookahead adder module
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;
    wire C16; // internal carry signal

    // instantiate two 16-bit CLA blocks
    cla_16bit u1(A[16:1], B[16:1], 1'b0, S[16:1], C16);
    cla_16bit u2(A[32:17], B[32:17], C16, S[32:17], C32);

endmodule