module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire case_00, case_01, case_10, case_11;

// First level: Group by ab combinations
assign case_00 = ~a & ~b;  // ab=00
assign case_01 = ~a & b;   // ab=01
assign case_10 = a & ~b;   // ab=10
assign case_11 = a & b;    // ab=11

// Second level: Evaluate cd based on ab
assign out = 
    (case_00 & (~c | ~d)) |       // ab=00: out=1 except cd=11
    (case_01 & (~c | d))  |       // ab=01: out=1 except cd=01
    (case_10 & (c | ~d))  |       // ab=10: out=1 except cd=10
    (case_11 & (c ^ d));          // ab=11: out=1 when cd=01,10,11

endmodule