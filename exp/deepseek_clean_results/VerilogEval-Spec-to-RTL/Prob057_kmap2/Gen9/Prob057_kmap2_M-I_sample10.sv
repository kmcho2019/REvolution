module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire term1, term2, term3, term4;

assign term1 = ~(~c & ~d & a & b);  // cd=00, ab=11
assign term2 = ~(~c & d & b);       // cd=01, b=1
assign term3 = ~(c & ~d & a);       // cd=10, a=1
assign term4 = ~(c & d & ~a & ~b);  // cd=11, ab=00

assign out = ~(term1 & term2 & term3 & term4);

endmodule