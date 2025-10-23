module TopModule (
    input x,       // First input bit
    input y,       // Second input bit
    output z       // Output: XNOR of x and y (x == y)
);
    // Continuous assignment implements XNOR function
    assign z = (x == y);
endmodule