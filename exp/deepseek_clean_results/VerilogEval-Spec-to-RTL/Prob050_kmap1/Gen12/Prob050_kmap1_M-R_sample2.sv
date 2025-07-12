module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Structural implementation of 3-input OR using two 2-input OR gates
    wire or_ab;
    
    or G1 (or_ab, a, b);
    or G2 (out, or_ab, c);
endmodule