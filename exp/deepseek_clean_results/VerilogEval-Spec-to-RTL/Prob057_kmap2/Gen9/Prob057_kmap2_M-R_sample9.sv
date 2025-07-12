module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Separate each product term
wire term1 = !a & !b & c & d;   // cd=11, ab=00
wire term2 = !c & d & b;        // cd=01, b=1
wire term3 = c & !d & a;        // cd=10, a=1
wire term4 = a & b & !c & !d;   // cd=00, ab=11

// Combine terms and invert
wire combined_terms = term1 | term2 | term3 | term4;
assign out = ~combined_terms;

endmodule