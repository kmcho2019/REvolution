module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] B_comp = ~B;      // One's complement of B
    wire cin = 1'b1;              // Carry-in for two's complement addition

    wire [63:0] P;    // Propagate signals
    wire [63:0] G;    // Generate signals
    wire [64:0] C;    // Carry signals (64 bits + carry out)

    assign P = A ^ B_comp;
    assign G = A & B_comp;

    assign C[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : carry_loop
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign result = P ^ C[63:0];

    // Overflow detection:
    // Overflow occurs if signs of A and B differ,
    // and sign of result differs from sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule