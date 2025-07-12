module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Optimal even parity checker implementation
    assign q = ~(a ^ b ^ c ^ d);
endmodule