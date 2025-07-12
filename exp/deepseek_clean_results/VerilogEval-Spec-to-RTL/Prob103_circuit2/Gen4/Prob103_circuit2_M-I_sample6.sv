module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire xnor_ab, xnor_cd;
    
    assign xnor_ab = ~(a ^ b);  // Equivalent to a XNOR b
    assign xnor_cd = ~(c ^ d);  // Equivalent to c XNOR d
    assign q = xnor_ab ^ xnor_cd;
endmodule