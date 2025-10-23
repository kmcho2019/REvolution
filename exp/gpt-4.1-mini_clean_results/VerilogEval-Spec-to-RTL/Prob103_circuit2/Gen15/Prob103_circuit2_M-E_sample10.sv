module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// From the truth table analysis, the minimized expression is:
// q = (~a & ~b & ~c & ~d) |
//     (~a & ~b &  c &  d) |
//     (~a &  b &  c & ~d) |
//     ( a &  b & ~c & ~d) |
//     ( a &  b &  c &  d) |
//     ( a & ~b &  c & ~d) |
//     ( a & ~b & ~c &  d) |
//     (~a &  b & ~c &  d)
//
// One simplified way is:
// q = (a ^ b) & (c ^ d) | (~a & ~b & ~c & ~d) | (a & b & c & d)

wire ab_xor = a ^ b;
wire cd_xor = c ^ d;
wire all_zero = ~a & ~b & ~c & ~d;
wire all_one  =  a &  b &  c &  d;

assign q = (ab_xor & cd_xor) | all_zero | all_one;

endmodule