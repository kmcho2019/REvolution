module TopModule (
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Continuous assignment for XNOR operation
endmodule