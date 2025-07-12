module TopModule (
    input x,
    input y,
    output z
);
    // Optimal XNOR implementation - no further optimization needed
    // Alternative expression that might map better to some cell libraries
    assign z = (x & y) | (~x & ~y);
endmodule