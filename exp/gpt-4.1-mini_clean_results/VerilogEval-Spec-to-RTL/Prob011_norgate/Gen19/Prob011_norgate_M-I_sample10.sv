module TopModule (
    input  a,
    input  b,
    output out
);
    // Minimal and direct NOR gate implementation using continuous assignment
    assign out = ~(a | b);
endmodule