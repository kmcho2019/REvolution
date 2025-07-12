module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Sum-of-Products (SOP) form:
// The minterms corresponding to the given input conditions are:
// - 2: !a & !b & c & !d
// - 7: !a & b & c & d
// - 15: a & b & c & d
assign out_sop = (!a & !b & c & !d) | (!a & b & c & d) | (a & b & c & d);

// Product-of-Sums (POS) form:
// The maxterms corresponding to the input conditions for which the output should be a logic-0 are:
// - 0: a | b | c | d
// - 1: a | b | c | !d
// - 4: a | !b | c | d
// - 5: a | !b | c | !d
// - 6: a | !b | !c | d
// - 9: !a | b | c | !d
// - 10: !a | b | !c | d
// - 13: !a | !b | c | d
// - 14: !a | !b | !c | !d
assign out_pos = (a | b | c | d) & (a | b | c | !d) & (a | !b | c | d) & (a | !b | c | !d) & (a | !b | !c | d) & (!a | b | c | !d) & (!a | b | !c | d) & (!a | !b | c | d) & (!a | !b | !c | !d);

endmodule