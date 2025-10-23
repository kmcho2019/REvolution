module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Novel solution using a MUX and an AND gate
wire sel;
assign sel = b & ~c;
assign q = (sel)? 1'b1 : c;

endmodule