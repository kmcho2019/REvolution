module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    localparam SIGN_BIT = 63;

    // Generate and Propagate signals for borrow calculation (subtraction)
    wire [63:0] g = A & (~B);          // Generate borrow if A=1 and B=0 => no borrow needed, but for subtraction borrow gen logic
    wire [63:0] p = ~(A ^ B);          // Propagate borrow if A and B are equal bits

    // Borrow chain: borrow[0] = 0 (no initial borrow)
    wire [64:0] borrow;
    assign borrow[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : borrow_calc
            assign borrow[i+1] = g[i] | (p[i] & borrow[i]);
        end
    endgenerate

    // Compute result bits considering borrow-in at each bit
    // result[i] = A[i] ^ B[i] ^ borrow[i]
    genvar j;
    generate
        for (j = 0; j < 64; j = j + 1) begin : result_calc
            assign result[j] = A[j] ^ B[j] ^ borrow[j];
        end
    endgenerate

    // Overflow detection (signed subtraction overflow)
    wire sign_A      = A[SIGN_BIT];
    wire sign_B      = B[SIGN_BIT];
    wire sign_result = result[SIGN_BIT];

    // Overflow if sign_A != sign_B and sign_result != sign_A
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule