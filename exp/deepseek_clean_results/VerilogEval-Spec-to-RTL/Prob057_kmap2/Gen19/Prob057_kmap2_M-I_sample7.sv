module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Direct implementation of K-map minimal cover
// Output is 1 unless any of the following conditions are true:
assign out = ~(
    (~a & ~b & c & d) |      // cd=11, ab=00
    (~a & b & ~c & d) |      // cd=01, ab=01
    (a & b & ~c & d) |       // cd=01, ab=11
    (a & b & c & ~d) |       // cd=10, ab=11
    (a & ~b & c & ~d) |      // cd=10, ab=10
    (~a & ~b & ~c & ~d & a & b)  // cd=00, ab=11 (simplified to a & b & ~c & ~d)
);

// Alternative implementation using POS form might be more efficient:
// assign out = (~a | ~d | b) & 
//              (~a | ~c | b) & 
//              (~b | c | ~d) & 
//              (a | ~b | ~c) & 
//              (a | ~b | d) & 
//              (~a | b | c | d);

endmodule