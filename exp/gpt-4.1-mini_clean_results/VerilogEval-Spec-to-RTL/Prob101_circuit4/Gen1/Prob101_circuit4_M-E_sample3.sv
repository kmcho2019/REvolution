module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// Using De Morgan's law: q = b | c = ~(~b & ~c)
assign q = ~(~b & ~c);

endmodule