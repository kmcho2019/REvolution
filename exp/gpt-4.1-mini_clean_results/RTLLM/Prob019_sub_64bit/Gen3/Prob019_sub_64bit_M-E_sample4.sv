module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Localparam for sign bit
    localparam SIGN_BIT = 63;

    // Step 1: Compute two's complement of B: ~B + 1
    wire [63:0] B_comp = ~B;

    // Generate propagate and generate signals for addition A + B_comp + 1
    wire [63:0] P; // propagate: P = A xor B_comp
    wire [63:0] G; // generate:  G = A & B_comp
    wire [64:0] C; // carry signals, C[0] = initial carry-in (1 due to +1)

    assign C[0] = 1'b1; // initial carry-in to add 1 in two's complement

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_pg
            assign P[i] = A[i] ^ B_comp[i];
            assign G[i] = A[i] & B_comp[i];
        end
    endgenerate

    // Carry-lookahead logic:
    // Carry-out at bit i+1: C[i+1] = G[i] | (P[i] & C[i])
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_carry
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Compute result bits: sum = P xor carry-in
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_sum
            assign result[i] = P[i] ^ C[i];
        end
    endgenerate

    // Extract sign bits for overflow detection
    wire sign_A      = A[SIGN_BIT];
    wire sign_B      = B[SIGN_BIT];
    wire sign_result = result[SIGN_BIT];

    // Overflow detection condition:
    // Overflow when sign_A != sign_B and sign_result != sign_A
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule