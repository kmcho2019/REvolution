module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum SOP form: (a'bcd) + (ab'cd) + (abcd)
assign out_sop = (~a & b & c & d) | (a & ~b & c & d) | (a & b & c & d);

// Minimum POS form: (a+b+c+d)' * (a'+b+c+d)' * (a+b'+c+d)' * (a+b'+c'+d)' * (a+b'+c'd)' * (a+b+c'+d)' * (a+b+c'+d')' * (a'+b+c+d')' * (a'+b+c'+d)'
// However, upon inspection, we see that this can be reduced by noticing that all 0's appear when at least one of the following maxterms is true:
// (a+b)' * (a+c)' * (b+c)'
assign out_pos = ~(~(a | b) | ~(a | c) | ~(b | c));

endmodule