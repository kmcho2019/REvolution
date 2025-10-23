module TopModule (
    input  x,
    input  y,
    output z
);
    // Direct continuous assignment using built-in operators to optimize synthesis
    assign z = (x ^ y) & x;
endmodule