module TopModule (
    input  a,
    input  b,
    output out
);
    // Direct behavioral assignment for NOR operation
    assign out = ~(a | b);
endmodule