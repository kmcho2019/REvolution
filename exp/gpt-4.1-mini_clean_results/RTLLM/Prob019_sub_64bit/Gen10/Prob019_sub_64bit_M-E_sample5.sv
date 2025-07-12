module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [64:0] borrow; // borrow chain signals between bits
    assign borrow[0] = 1'b0; // no initial borrow-in for subtraction

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : bit_subtractors
            full_subtractor_1bit fsb (
                .a     (A[i]),
                .b     (B[i]),
                .bin   (borrow[i]),
                .diff  (result[i]),
                .bout  (borrow[i+1])
            );
        end
    endgenerate

    // Overflow detection:
    // Overflow occurs when the sign of A and B differ AND the result sign differs from A sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule

// 1-bit full subtractor
// Inputs:
//   a    - minuend bit
//   b    - subtrahend bit
//   bin  - borrow-in from previous less significant bit
// Outputs:
//   diff - difference bit (a - b - bin)
//   bout - borrow-out to next more significant bit
module full_subtractor_1bit (
    input  wire a,
    input  wire b,
    input  wire bin,
    output wire diff,
    output wire bout
);
    // Difference bit: diff = a XOR b XOR borrow_in
    assign diff = a ^ b ^ bin;

    // Borrow out logic:
    // bout = (~a & b) | ((~a | b) & bin)
    assign bout = (~a & b) | ((~a | b) & bin);

endmodule