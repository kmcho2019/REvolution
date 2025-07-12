module TopModule (
    input  a,
    input  b,
    output out
);
    // Directly implement NOR function with a continuous assignment
    assign out = ~(a | b);
endmodule