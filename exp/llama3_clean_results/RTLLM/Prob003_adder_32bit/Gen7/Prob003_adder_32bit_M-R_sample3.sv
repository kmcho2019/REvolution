module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [32:1] G, P;
    wire [31:1] C;

    // Calculate G and P values
    for (genvar i = 1; i <= 32; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    // Calculate C values
    assign C[1] = G[1];
    for (genvar i = 2; i <= 31; i++) begin
        assign C[i] = G[i] + (P[i] & C[i-1]);
    end
    assign C32 = G[32] + (P[32] & C[31]);

    // Calculate S values
    assign S[1] = P[1];
    for (genvar i = 2; i <= 32; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end

endmodule