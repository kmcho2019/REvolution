module TopModule (
    input x,
    input y,
    output z
);
    // Direct XNOR implementation - already optimal
    assign z = ~(x ^ y);
endmodule