module TopModule (
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Single XNOR gate - minimal implementation
endmodule