module TopModule (
    input x,
    input y,
    output z
);
    // Optimized implementation of z = (x^y) & x
    // Boolean algebra reduction: (x^y) & x = x & ~y
    // This implementation uses a single AND gate with y inverted
    // for minimal area and power consumption
    assign z = x & ~y;
endmodule