module TopModule(
    input x,
    input y,
    output z
);
    // Using the efficient logical expression for the XNOR gate
    assign z =!(x ^ y);
endmodule