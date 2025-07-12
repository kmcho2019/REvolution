module TopModule (
    input  a,
    input  b,
    output out
);
    // Continuous assignment using bitwise NOR operator
    assign out = ~(a | b);
endmodule