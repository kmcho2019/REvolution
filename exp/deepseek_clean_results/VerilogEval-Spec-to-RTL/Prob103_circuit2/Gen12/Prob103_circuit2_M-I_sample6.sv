module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Optimized implementation using single XNOR operation
    assign q = ~(a ^ b ^ c ^ d);  // This is equivalent to XNOR
    // Alternative syntax if XNOR is preferred:
    // assign q = a ~^ b ~^ c ~^ d;
endmodule