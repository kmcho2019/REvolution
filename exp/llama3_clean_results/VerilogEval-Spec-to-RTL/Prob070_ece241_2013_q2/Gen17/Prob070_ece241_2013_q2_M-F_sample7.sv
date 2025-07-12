module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Implement the SOP expression using logical operations
assign out_sop = ((~a & ~b & c & ~d) | 
                  (~a & b & c & d) | 
                  (a & b & c & d));

// Implement the POS expression using the relationship between SOP and POS
// Since the POS expression is the dual of the SOP expression, we can derive it by:
// 1. Finding the dual of each term in the SOP expression (i.e., replacing AND with OR and vice versa, and replacing variables with their complements)
// 2. Combining the dual terms using AND operations

// The dual of (~a & ~b & c & ~d) is (a | b | ~c | d)
// The dual of (~a & b & c & d) is (a | ~b | ~c | ~d)
// The dual of (a & b & c & d) is (~a | ~b | ~c | ~d)

assign out_pos = ((a | b | ~c | d) & 
                 (a | ~b | ~c | ~d) & 
                 (~a | ~b | ~c | ~d));

endmodule