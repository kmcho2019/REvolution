module TopModule(
    input  x,
    input  y,
    output z
);
    // Output is XNOR of inputs x and y
    assign z = ~(x ^ y);
endmodule