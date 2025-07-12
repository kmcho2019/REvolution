module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire temp;

assign temp = b || c;
assign q = temp;

// Alternative implementation using a conditional expression
// assign q = (b == 1'b1) || (c == 1'b1);

endmodule