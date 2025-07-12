module TopModule(
    input  x,
    input  y,
    output z
);
    assign z = ~(x ^ y); // Equivalent to XNOR
endmodule