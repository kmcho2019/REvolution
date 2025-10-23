module TopModule (
    input x,
    input y,
    output z
);
    // Optimal XNOR implementation - alternative form that might map better
    // to some standard cell libraries
    assign z = (x & y) | (~x & ~y);
endmodule