module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

wire ab = a & b;
wire aorb = a | b;
wire not_ab = ~ab;

wire term0 = (nd & not_ab) | (d & nb);       // (~d & ~(a&b)) | (d & ~b)
wire term1 = (d & aorb) | (nd & not_ab);    // (d & (a|b)) | (~d & ~(a&b))

assign out = (nc & term0) | (c & term1);

endmodule