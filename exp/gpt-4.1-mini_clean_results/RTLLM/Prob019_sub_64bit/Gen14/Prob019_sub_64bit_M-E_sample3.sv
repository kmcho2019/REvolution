module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] B_neg = ~B;          // One's complement of B
    wire [63:0] sum;                 // sum = A + B_neg + 1 (subtract)
    wire [63:0] result_r;
    wire        borrow_in;           // initial borrow in for subtraction is 1 (for +1)
    wire [63:0] carry;               // borrow chain for each bit

    assign borrow_in = 1'b1;         // subtraction: A + (~B) + 1

    // Ripple borrow subtractor bitwise implementation
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : bit_sub
            wire a_bit = A[i];
            wire b_bit = B_neg[i];
            wire carry_prev = (i == 0) ? borrow_in : carry[i-1];

            // sum bit: a ^ b ^ carry_in (borrow in)
            assign sum[i] = a_bit ^ b_bit ^ carry_prev;

            // borrow out for next bit
            // borrow_out = (~a & (b | carry_in)) | (b & carry_in)
            assign carry[i] = (~a_bit & (b_bit | carry_prev)) | (b_bit & carry_prev);
        end
    endgenerate

    assign result_r = sum;
    assign result = result_r;

    // Overflow detection for signed subtraction:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule