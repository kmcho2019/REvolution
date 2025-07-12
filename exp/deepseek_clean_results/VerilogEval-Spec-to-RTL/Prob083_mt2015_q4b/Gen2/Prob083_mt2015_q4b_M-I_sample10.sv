module TopModule (
    input x,
    input y,
    output z
);
    // Maintain optimal XNOR implementation
    assign z = ~(x ^ y);
endmodule