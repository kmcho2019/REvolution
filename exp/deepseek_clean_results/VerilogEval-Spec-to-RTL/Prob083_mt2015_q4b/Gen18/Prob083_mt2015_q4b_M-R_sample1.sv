module TopModule (
    input x,
    input y,
    output z
);
    // Implement XNOR using equality check
    assign z = (x == y) ? 1'b1 : 1'b0;
endmodule