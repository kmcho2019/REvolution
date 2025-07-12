module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Correct derivation of SOP expression using K-maps
assign out_sop = (b & ~a & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Correct derivation of POS expression using K-maps
assign out_pos = ~(~a & ~b & ~c & ~d) & ~(~a & ~b & ~c & d) & ~(~a & ~b & c & ~d) & ~(~a & ~b & c & d) & ~(~a & b & ~c & ~d) & ~(~a & b & ~c & d) & ~(~a & b & c & ~d) & ~(a & ~b & ~c & ~d) & ~(a & ~b & ~c & d) & ~(a & ~b & c & ~d) & ~(a & ~b & c & d) & ~(a & b & ~c & ~d) & ~(a & b & ~c & d);

// Alternative implementation using case statement
// assign out_sop = (a == 0 && b == 1 && c == 0 && d == 0) || 
//                 (a == 0 && b == 1 && c == 1 && d == 1) || 
//                 (a == 1 && b == 1 && c == 1 && d == 1);

// Alternative implementation using case statement
// assign out_pos = ~( (a == 0 && b == 0 && c == 0 && d == 0) || 
//                    (a == 0 && b == 0 && c == 0 && d == 1) || 
//                    (a == 0 && b == 0 && c == 1 && d == 0) || 
//                    (a == 0 && b == 0 && c == 1 && d == 1) || 
//                    (a == 0 && b == 1 && c == 0 && d == 0) || 
//                    (a == 0 && b == 1 && c == 0 && d == 1) || 
//                    (a == 0 && b == 1 && c == 1 && d == 0) || 
//                    (a == 1 && b == 0 && c == 0 && d == 0) || 
//                    (a == 1 && b == 0 && c == 0 && d == 1) || 
//                    (a == 1 && b == 0 && c == 1 && d == 0) || 
//                    (a == 1 && b == 0 && c == 1 && d == 1) || 
//                    (a == 1 && b == 1 && c == 0 && d == 0) || 
//                    (a == 1 && b == 1 && c == 0 && d == 1) );

endmodule