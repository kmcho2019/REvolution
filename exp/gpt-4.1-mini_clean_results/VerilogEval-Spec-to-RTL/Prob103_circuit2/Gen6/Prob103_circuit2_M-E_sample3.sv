module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire parity_bcd;
assign parity_bcd = b ^ c ^ d;
assign q = a ? parity_bcd : ~parity_bcd;

endmodule