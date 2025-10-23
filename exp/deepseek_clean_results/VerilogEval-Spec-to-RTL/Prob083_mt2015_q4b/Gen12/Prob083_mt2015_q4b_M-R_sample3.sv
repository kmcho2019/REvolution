module TopModule (
    input x,
    input y,
    output z
);
    // Direct XNOR implementation using a single continuous assignment
    assign z = ~(x ^ y);
endmodule