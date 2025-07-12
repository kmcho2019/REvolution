module TopModule (
    input  a,
    input  b,
    output out
);
    // Use continuous assignment with bitwise negation of the OR of inputs to implement NOR
    assign out = ~(a | b);
endmodule