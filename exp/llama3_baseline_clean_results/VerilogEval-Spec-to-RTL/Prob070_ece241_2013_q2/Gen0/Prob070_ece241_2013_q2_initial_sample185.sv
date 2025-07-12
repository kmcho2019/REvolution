module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form
assign out_sop = 
    (~a & ~b &  c & ~d) |  // minterm for 2
    (~a &  b &  c &  d) |  // minterm for 7
    ( a &  b &  c &  d);    // minterm for 15

// Minimum Product-of-Sums (POS) form
// The maxterms for 0, 1, 4, 5, 6, 9, 10, 13, 14 are:
// 0: a | b | c | d
// 1: a | b | c | ~d
// 4: a | ~b | ~c | ~d
// 5: a | ~b | ~c | d
// 6: a | ~b | c | ~d
// 9: a | b | ~c | ~d
// 10: a | b | ~c | d
// 13: ~a | b | ~c | d
// 14: ~a | b | ~c | ~d
// Implementing the POS form directly is complex due to the need to handle don't-care conditions for inputs 3, 8, 11, and 12.
// However, the POS form can be obtained by finding the dual of the SOP form for the complement of the function and then inverting the result.

assign out_pos = ~( 
    (a | b | ~c | ~d) &  // maxterm for 0
    (a | b | ~c | d) &   // maxterm for 1
    (~a | ~b | c | ~d) & // maxterm for 4
    (~a | ~b | c | d) &  // maxterm for 5
    (~a | ~b | ~c | ~d) &// maxterm for 6
    (~a | b | ~c | ~d) & // maxterm for 9
    (~a | b | ~c | d) &  // maxterm for 10
    (a | ~b | ~c | ~d) & // maxterm for 13
    (a | ~b | ~c | d)    // maxterm for 14
);

endmodule