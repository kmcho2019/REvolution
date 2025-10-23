module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Optimal 2-to-1 mux implementation using ternary operator
    // Implements: out = (sel & b) | (~sel & a) in most efficient way
    assign out = sel ? b : a;
endmodule