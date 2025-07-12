module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    wire [3:0] in_val = {a, b, c, d};

    // out_sop is 1 when in_val equals 2, 7, or 15
    assign out_sop = (in_val == 4'd2) | (in_val == 4'd7) | (in_val == 4'd15);

    // For out_pos, product-of-sums form
    // Logic-0 for values: 0,1,4,5,6,9,10,13,14
    // For each zero input, create a sum term that is 0 for that input and 1 otherwise.
    // POS = AND of all these sum terms.

    // Sum term for zero=0  (0000): (a + b + c + d)
    wire sum0  = a | b | c | d;

    // zero=1  (0001): (a + b + c + ~d)
    wire sum1  = a | b | c | ~d;

    // zero=4  (0100): (a + ~b + c + d)
    wire sum4  = a | ~b | c | d;

    // zero=5  (0101): (a + ~b + c + ~d)
    wire sum5  = a | ~b | c | ~d;

    // zero=6  (0110): (a + ~b + ~c + d)
    wire sum6  = a | ~b | ~c | d;

    // zero=9  (1001): (~a + b + c + ~d)
    wire sum9  = ~a | b | c | ~d;

    // zero=10 (1010): (~a + b + ~c + d)
    wire sum10 = ~a | b | ~c | d;

    // zero=13 (1101): (~a + ~b | c | ~d)
    wire sum13 = ~a | ~b | c | ~d;

    // zero=14 (1110): (~a + ~b | ~c | d)
    wire sum14 = ~a | ~b | ~c | d;

    assign out_pos = sum0 & sum1 & sum4 & sum5 & sum6 & sum9 & sum10 & sum13 & sum14;

endmodule