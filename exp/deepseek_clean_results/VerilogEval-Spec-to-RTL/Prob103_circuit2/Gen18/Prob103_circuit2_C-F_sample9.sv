module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Hierarchical XNOR implementation for optimal synthesis
    assign q = ~( (a ^ b) ^ (c ^ d) );
endmodule