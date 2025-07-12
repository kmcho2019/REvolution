module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate signals for common patterns
wire case_cd00 = ~c & ~d;
wire case_cd01 = ~c & d;
wire case_cd10 = c & ~d;
wire case_cd11 = c & d;

// Group terms by cd cases
wire term1 = case_cd00 & a & b;    // cd=00, ab=11
wire term2 = case_cd01 & (~a & b | a & b); // cd=01, ab=01 or 11
wire term3 = case_cd10 & (a & b | a & ~b); // cd=10, ab=11 or 10
wire term4 = case_cd11 & ~a & ~b;  // cd=11, ab=00

// Combine terms with balanced OR tree
wire or_stage1 = term1 | term2;
wire or_stage2 = term3 | term4;
assign out = ~(or_stage1 | or_stage2);

endmodule