module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Inputs as bits with a = MSB, d = LSB
    // Decimal values to check:
    // out_sop = 1 for inputs 2(0010),7(0111),15(1111)
    // out_sop = 0 for inputs 0,1,4,5,6,9,10,13,14
    // inputs 3,8,11,12 are don't cares (never occur)

    // Explicit complements for clarity and synthesis safety
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // SOP minterms for out_sop=1:
    // 2  = 0 0 1 0 => ~a & ~b &  c & ~d
    // 7  = 0 1 1 1 => ~a &  b &  c &  d
    // 15 = 1 1 1 1 =>  a &  b &  c &  d

    wire term_2  = na & nb & c & nd;
    wire term_7  = na & b  & c & d;
    wire term_15 = a  & b  & c & d;

    assign out_sop = term_2 | term_7 | term_15;

    // POS expression for out_pos=1 for zero outputs:
    // zeros: 0,1,4,5,6,9,10,13,14
    // POS derived:
    // out_pos = (a + b + ~c + d) & (~a + b + ~c + ~d) & (~a + ~b + ~c + d)

    wire sum1 = a | b | nc | d;
    wire sum2 = na | b | nc | nd;
    wire sum3 = na | nb | nc | d;

    assign out_pos = sum1 & sum2 & sum3;

endmodule