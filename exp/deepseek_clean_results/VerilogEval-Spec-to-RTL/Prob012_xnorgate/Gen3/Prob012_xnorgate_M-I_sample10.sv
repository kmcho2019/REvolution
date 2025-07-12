module TopModule (
    input a,
    input b,
    output out
);
    // Optimal implementation: Single XNOR operation (maps to standard cell)
    // Equivalent to: (a & b) | (~a & ~b) but more compact
    assign out = ~(a ^ b);
endmodule