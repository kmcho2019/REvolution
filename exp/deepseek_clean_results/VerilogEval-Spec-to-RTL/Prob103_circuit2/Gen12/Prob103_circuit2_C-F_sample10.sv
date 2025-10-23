module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Even parity checker: output 1 when even number of inputs are 1
    // Implemented as inverted XOR of all inputs (a^b^c^d gives odd parity)
    assign q = ~(a ^ b ^ c ^ d);
endmodule