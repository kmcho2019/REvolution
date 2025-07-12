module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

wire all_zero = ~(a | b | c | d);
wire parity = a ^ b ^ c ^ d;

assign q = all_zero | ~parity;

endmodule