module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Already optimal implementation - keeping original
    assign out = a | b | c;
endmodule