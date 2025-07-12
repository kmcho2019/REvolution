// 16-bit CLA block with direct implementation
module cla_16bit(
    input [16:1] A, B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire [15:1] G, P, C;

    // Generate and Propagate signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    for (genvar i = 2; i <= 16; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end

    // Carry calculation
    assign C[1] = G[1] | (P[1] & Cin);
    for (genvar i = 2; i <= 15; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end
    assign Cout = G[16] | (P[16] & C[15]);

    // Sum calculation
    assign S[1] = A[1] ^ B[1] ^ Cin;
    for (genvar i = 2; i <= 16; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end
endmodule

// 32-bit CLA block
module adder_32bit(
    input [32:1] A, B,
    output [32:1] S,
    output C32
);
    wire Cout1;

    cla_16bit cla1(A[16:1], B[16:1], 1'b0, S[16:1], Cout1);
    cla_16bit cla2(A[32:17], B[32:17], Cout1, S[32:17], C32);
endmodule