module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Optimal implementation: 3-input OR gate (minimal area and timing)
    // Alternative for power optimization: out = ~(~a & ~b & ~c)
    assign out = (a | b | c);
endmodule