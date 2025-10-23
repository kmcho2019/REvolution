module TopModule (
    input x,
    input y,
    output z
);
    // Direct XNOR implementation - most efficient solution
    assign z = ~(x ^ y);
endmodule