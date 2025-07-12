module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Maintain the optimal implementation
    assign out = a | b | c;
endmodule