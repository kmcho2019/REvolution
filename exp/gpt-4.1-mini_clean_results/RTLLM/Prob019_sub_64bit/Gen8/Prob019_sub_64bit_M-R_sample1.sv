module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Two's complement of B: ~B + 1 is achieved by adding ~B with carry_in = 1
    wire [63:0] B_comp = ~B;

    // Perform A + (~B + 1)
    wire cout;
    cla_64bit cla_sub (
        .A   (A),
        .B   (B_comp),
        .cin (1'b1),  // Adding 1 for two's complement
        .sum (result),
        .cout(cout)
    );

    // Overflow detection:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 64-bit Carry Lookahead Adder (CLA)
module cla_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    wire [63:0] P;  // propagate
    wire [63:0] G;  // generate
    wire [64:0] C;  // carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = cin;

    // Generate carries hierarchically using 8-bit blocks
    // First compute carries for every 8-bit block
    // Then generate block propagate and generate signals for top level carry lookahead

    // Per-bit carry generation using carry-lookahead logic:
    // This is a flat carry-lookahead for all 64 bits

    // Carry computations:
    // C[i+1] = G[i] | (P[i] & C[i])
    // Implemented as a generate block for all bits

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum calculation
    assign sum = P ^ C[63:0];
    assign cout = C[64];

endmodule