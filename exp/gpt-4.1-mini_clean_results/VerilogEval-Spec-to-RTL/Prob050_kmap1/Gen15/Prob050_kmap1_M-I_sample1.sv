// Parameterized 2-input OR gate module (for modular design)
module Or2 (
    input  x,
    input  y,
    output z
);
    assign z = x | y;
endmodule

// TopModule implements the K-map function: out = a + b + c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire ab_or;

    // Balanced two-level OR implementation for potential timing improvement
    Or2 or1 (.x(a), .y(b), .z(ab_or));
    Or2 or2 (.x(ab_or), .y(c), .z(out));
endmodule