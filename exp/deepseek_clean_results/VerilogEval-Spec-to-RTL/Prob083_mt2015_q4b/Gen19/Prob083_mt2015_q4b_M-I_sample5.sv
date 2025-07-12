module TopModule (
    input x,
    input y,
    output z
);
    // Implement XNOR using fundamental gates
    assign z = (x & y) | (~x & ~y);
endmodule