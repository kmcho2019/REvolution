module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Maintain optimal implementation - cannot be improved further
    assign out = a | b | c;
endmodule