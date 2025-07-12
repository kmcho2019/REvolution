module TopModule(
    input a,
    input b,
    input c,
    input d,  // Explicitly unused
    output out
);
    // Optimized implementation that may have better PPA
    assign out = a | (~b & c);
endmodule