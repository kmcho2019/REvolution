// Optional gate-level module definitions (for educational purposes):
/*
module Or2 (
    input  x,
    input  y,
    output z
);
    assign z = x | y;
endmodule

module Or3 (
    input  x,
    input  y,
    input  w,
    output z
);
    wire t;
    Or2 or1 (.x(x), .y(y), .z(t));
    Or2 or2 (.x(t), .y(w), .z(z));
endmodule
*/

// TopModule implements the K-map function: out = a + b + c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Minimal and optimal implementation using continuous assignment
    assign out = a | b | c;
endmodule