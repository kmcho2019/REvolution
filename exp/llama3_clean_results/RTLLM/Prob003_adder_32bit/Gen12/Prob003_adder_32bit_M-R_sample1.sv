// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [15:1] C1; // Carry signals for first 16-bit segment
    wire [15:1] C2; // Carry signals for second 16-bit segment

    // First 16-bit segment
    assign C1[1] = A[1] & B[1];
    for (genvar i = 2; i <= 15; i++) begin
        assign C1[i] = A[i] & B[i] | (A[i] ^ B[i]) & C1[i-1];
    end

    // Predictive carry-in for second segment
    wire C_in2 = C1[15];

    // Second 16-bit segment
    assign C2[1] = A[16] & B[16];
    for (genvar i = 2; i <= 15; i++) begin
        assign C2[i] = A[i+15] & B[i+15] | (A[i+15] ^ B[i+15]) & C2[i-1];
    end
    assign C32 = A[32] & B[32] | (A[32] ^ B[32]) & C2[15];

    // Sum calculations
    assign S[1] = A[1] ^ B[1];
    for (genvar i = 2; i <= 15; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C1[i-1];
    end
    assign S[16] = A[16] ^ B[16] ^ C_in2;
    for (genvar i = 17; i <= 32; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C2[i-16];
    end

endmodule