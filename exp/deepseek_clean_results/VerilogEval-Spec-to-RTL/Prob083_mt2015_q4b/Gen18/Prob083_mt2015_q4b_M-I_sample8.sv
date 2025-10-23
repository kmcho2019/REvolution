module TopModule (
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Optimal XNOR implementation
endmodule