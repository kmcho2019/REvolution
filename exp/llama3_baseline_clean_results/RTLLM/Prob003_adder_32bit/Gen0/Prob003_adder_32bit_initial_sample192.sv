// Define the 16-bit CLA block
module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A, B;
    input Cin;
    output [16:1] S;
    output Cout;

    wire [16:1] G, P;
    wire [15:0] C;

    // Compute generate and propagate signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign C[0] = Cin;

    // Compute carry and sum signals
    genvar i;
    generate
        for (i = 2; i <= 16; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
            assign C[i-1] = G[i-1] | (P[i-1] & C[i-2]);
        end
    endgenerate

    // Compute final sum and carry-out signals
    assign S[1] = A[1] ^ B[1] ^ Cin;
    generate
        for (i = 2; i <= 16; i++) begin
            assign S[i] = A[i] ^ B[i] ^ C[i-1];
        end
    endgenerate
    assign Cout = G[16] | (P[16] & C[15]);
endmodule

// Define the top module: 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    wire Cout_lower;

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_lower(A[16:1], B[16:1], 1'b0, S[16:1], Cout_lower);
    cla_16bit cla_upper(A[32:17], B[32:17], Cout_lower, S[32:17], C32);
endmodule