module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Technology-optimal implementation using ternary operator
    // Let synthesis tool choose best implementation (gate or pass-transistor)
    wire out = sel ? b : a;
endmodule