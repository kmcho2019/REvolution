module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Define the minterms for SOP
wire minterm_2 = ~a & b & ~c & ~d;
wire minterm_7 = ~a & b & c & d;
wire minterm_15 = a & b & c & d;

// Define the SOP expression
assign out_sop = minterm_2 | minterm_7 | minterm_15;

// Define the POS expression using De Morgan's laws
assign out_pos = ~(~a & ~b & ~c & ~d) & ~(~a & ~b & ~c & d) & ~(~a & b & ~c & ~d) & ~(~a & b & ~c & d) & ~(~a & b & c & ~d) & ~(a & ~b & ~c & d) & ~(a & ~b & c & ~d) & ~(a & b & ~c & d) & ~(a & b & c & ~d);

// Alternatively, the POS expression can be simplified as follows
// assign out_pos = (a | ~b | c | d) & (~a | b | ~c | d) & (~a | ~b | c | d) & (~a | ~b | ~c | ~d) & (a | b | ~c | ~d) & (~a | ~b | ~c | ~d) & (a | ~b | c | ~d) & (~a | b | c | ~d) & (~a | b | ~c | ~d);

endmodule