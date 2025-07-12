module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    assign q = ~(a ^ b ^ c ^ d);  // Equivalent to a XNOR b XNOR c XNOR d
endmodule