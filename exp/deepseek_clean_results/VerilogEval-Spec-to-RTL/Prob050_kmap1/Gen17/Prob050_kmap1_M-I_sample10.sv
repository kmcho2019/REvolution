module TopModule (
    input a,
    input b,
    input c,
    output out
);
    assign out = a | b | c;  // Maintain optimal implementation
endmodule