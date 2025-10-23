module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) expression for out_sop
assign out_sop = (~a & b & ~c & d) | (~a & b & c & d) | (a & b & c & d);

// Minimum Product-of-Sums (POS) expression for out_pos
// Since we are directly implementing based on given conditions and simplification might be needed,
// let's first list the conditions that result in 0 and then find the product of sums.
// The expression is the product of the sums of the complements of minterms that would produce a '0'.
assign out_pos = (a | b | c | d) & (a | b | c | ~d) & (a | ~b | c | d) & (a | ~b | c | ~d) & (a | ~b | ~c | d) & (~a | b | c | ~d) & (~a | b | ~c | d) & (~a | ~b | c | ~d) & (~a | ~b | ~c | d);

endmodule