module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire term1 = ~c & ~d;          // c'd'
wire term2 = c & ~d;           // cd'
wire term3 = ~a & b;           // a'b
wire term4 = a & b;            // ab

assign out = term1 | term2 | term3 | term4;

endmodule