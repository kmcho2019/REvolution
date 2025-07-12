module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] diff;
    wire [63:0] borrow;

    // Instantiate 64 1-bit subtractors chained with borrow ripple
    // borrow[0] is initial borrow_in = 0 (no borrow-in)
    assign borrow[0] = 1'b0;

    genvar i;
    generate
        for(i=0; i<64; i=i+1) begin : gen_subtractors
            one_bit_subtractor u_sub (
                .a    (A[i]),
                .b    (B[i]),
                .bin  (borrow[i]),
                .diff (diff[i]),
                .bout (borrow[i+1])
            );
        end
    endgenerate

    assign result = diff;

    // Overflow detection
    // Overflow occurs if sign bits of A and B differ,
    // and sign of result differs from sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule

// 1-bit full subtractor: diff = a - b - bin
// Outputs difference bit and borrow out bit
module one_bit_subtractor (
    input  wire a,    // minuend bit
    input  wire b,    // subtrahend bit
    input  wire bin,  // borrow in
    output wire diff, // difference bit
    output wire bout  // borrow out
);
    // Difference = a - b - bin
    // Can be implemented using XOR and borrow logic:
    assign diff = a ^ b ^ bin;

    // Borrow out logic:
    // Borrow occurs if a < (b + bin)
    // borrow out = (~a & b) | ((~a | b) & bin)
    assign bout = (~a & b) | ((~a | b) & bin);

endmodule