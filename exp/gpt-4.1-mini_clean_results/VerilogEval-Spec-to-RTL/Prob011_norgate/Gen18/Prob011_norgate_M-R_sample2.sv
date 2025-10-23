module TopModule (
    input  a,
    input  b,
    output out
);
    // Directly implement NOR function with a continuous assign statement
    assign out = ~(a | b);
endmodule