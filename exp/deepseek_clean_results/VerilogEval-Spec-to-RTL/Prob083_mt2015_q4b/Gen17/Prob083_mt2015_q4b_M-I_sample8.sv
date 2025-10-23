module TopModule (
    input x,
    input y,
    output z
);
    // Maintain the optimal XNOR implementation
    assign z = ~(x ^ y);
endmodule