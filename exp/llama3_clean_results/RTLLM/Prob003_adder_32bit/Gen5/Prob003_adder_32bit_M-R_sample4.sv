// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [32:1] G, P; // Generate and Propagate signals
    wire [32:1] C;    // Carry signals

    // Calculate Generate and Propagate signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign S[1] = A[1] ^ B[1];

    // Calculate Generate, Propagate, and Carry signals for the rest of the bits
    genvar i;
    generate
        for (i = 2; i <= 32; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];

            // Calculate carry signal
            if (i == 2) begin
                assign C[i] = G[i-1] | (P[i-1] & 1'b0); // For the first bit, there's no previous carry
            end else begin
                assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
            end

            // Calculate sum signal
            assign S[i] = A[i] ^ B[i] ^ C[i];
        end
    endgenerate

    // Carry out
    assign C32 = G[32] | (P[32] & C[32]);
endmodule