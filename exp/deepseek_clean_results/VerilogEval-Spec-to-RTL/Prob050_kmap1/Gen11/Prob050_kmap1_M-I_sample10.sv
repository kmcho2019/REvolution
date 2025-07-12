module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Optimal implementation - cannot be improved further
    assign out = a | b | c;
endmodule