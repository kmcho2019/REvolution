module TopModule (
    input x,
    input y,
    output z
);
    // Direct implementation of XNOR function
    assign z = ~(x ^ y);
    // Alternative equivalent implementation:
    // assign z = (x == y);
endmodule