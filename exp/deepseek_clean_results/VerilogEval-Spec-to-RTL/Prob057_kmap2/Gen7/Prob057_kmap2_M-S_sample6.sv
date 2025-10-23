module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire term1 = ~a & ~b;       // a'b'
wire term2 = ~a & c;        // a'c
wire term3 = b & d;         // bd
wire term4 = a & ~c & ~d;   // ac'd'

assign out = term1 | term2 | term3 | term4;

endmodule