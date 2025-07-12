module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

// Even parity checker (XNOR of all inputs)
assign q = ~(a ^ b ^ c ^ d);

endmodule