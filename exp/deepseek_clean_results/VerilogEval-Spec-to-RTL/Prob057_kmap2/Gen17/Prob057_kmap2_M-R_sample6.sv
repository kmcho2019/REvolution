module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire term1 = ~a & ~b & c & d;
wire term2 = b & ~c & d;
wire term3 = a & c & ~d;
wire term4 = a & b & ~c & ~d;
wire combined_terms = term1 | term2 | term3 | term4;

assign out = ~combined_terms;

endmodule