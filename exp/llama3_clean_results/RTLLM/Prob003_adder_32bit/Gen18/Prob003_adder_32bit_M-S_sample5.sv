// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [31:1] C;
    wire [32:1] G, P; // Generate and Propagate signals

    // Compute Generate (G) and Propagate (P) signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    generate
        for (genvar i = 2; i <= 32; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
        end
    endgenerate

    // Compute carry bits using G and P
    assign C[1] = G[1];
    generate
        for (genvar i = 2; i <= 31; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Compute sum bits
    assign S[1] = P[1] ^ 1'b0; // Assuming no input carry for the first bit
    generate
        for (genvar i = 2; i <= 32; i++) begin
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    // Compute carry-out
    assign C32 = G[32] | (P[32] & C[31]);

endmodule