module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Optimal implementation - cannot be improved further
    assign out = a | (~b & c);
endmodule