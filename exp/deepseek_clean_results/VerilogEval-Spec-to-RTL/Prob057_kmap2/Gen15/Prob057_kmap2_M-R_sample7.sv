module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Separate product terms as intermediate wires
wire term1 = ~a & ~b & c & d;  // cd=11,ab=00
wire term2 = b & ~c & d;        // cd=01 cases
wire term3 = a & c & ~d;        // cd=10 cases
wire term4 = a & b & ~c & ~d;   // cd=00,ab=11

// Final NOR implementation
assign out = ~(term1 | term2 | term3 | term4);

endmodule