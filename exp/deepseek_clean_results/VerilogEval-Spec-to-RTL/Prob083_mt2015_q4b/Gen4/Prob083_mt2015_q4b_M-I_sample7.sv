// Implementation 1: Direct XNOR (original optimal solution)
module TopModule (
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Most compact implementation
endmodule

// Implementation 2: Alternative expression (might be better in some libraries)
/*
module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x & y) | (~x & ~y);  // Alternative XNOR implementation
endmodule
*/