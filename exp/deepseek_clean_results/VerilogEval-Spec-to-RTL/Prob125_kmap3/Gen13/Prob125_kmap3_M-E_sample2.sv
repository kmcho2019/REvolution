module TopModule(
    input a,
    input b,
    input c,
    input d,  // Unused
    output out
);
    // Priority implementation: a has highest priority
    assign out = a | (~b & c);
endmodule