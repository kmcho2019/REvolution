// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [31:1] G;  // Generate
    wire [31:1] P;  // Propagate
    wire [31:1] C;  // Carry

    // Calculate Generate and Propagate signals
    for (genvar i = 1; i <= 32; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end

    // Calculate Carry signals
    assign C[1] = G[1] | (P[1] & 1'b0);
    for (genvar i = 2; i <= 32; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end

    // Calculate Sum signals
    for (genvar i = 1; i <= 32; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end

    // Calculate final Carry-out
    assign C32 = G[32] | (P[32] & C[31]);

endmodule