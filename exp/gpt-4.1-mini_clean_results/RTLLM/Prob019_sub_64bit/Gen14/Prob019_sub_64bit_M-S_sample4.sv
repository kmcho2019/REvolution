module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] B_comp = ~B;
    wire [64:0] carry;
    wire [63:0] sum;

    assign carry[0] = 1'b1;  // Initial carry-in for two's complement addition (A + ~B + 1)

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : ripple_adder
            assign sum[i] = A[i] ^ B_comp[i] ^ carry[i];
            assign carry[i+1] = (A[i] & B_comp[i]) | (A[i] & carry[i]) | (B_comp[i] & carry[i]);
        end
    endgenerate

    assign result = sum;

    // Overflow detection:
    // Overflow if signs of A and B differ and result sign differs from A's sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule