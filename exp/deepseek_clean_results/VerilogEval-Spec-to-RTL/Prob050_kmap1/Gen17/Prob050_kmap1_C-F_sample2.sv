module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Optimal implementation: OR of all inputs
    // Matches K-map where output is 0 only when a=b=c=0
    // This is the minimal gate-count implementation (single 3-input OR)
    assign out = a | b | c;
endmodule