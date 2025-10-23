module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Break down into intermediate terms
wire term1 = ~a & ~b & c & d;
wire term2 = a & b & ~c;
wire term3 = a & b & ~d;
wire term4 = (b & ~c & d) | (a & c & ~d);

// Final NOR implementation
assign out = ~(term1 | term2 | term3 | term4);

endmodule