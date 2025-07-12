module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // Using XOR and then inverting to get XNOR behavior

// Alternatively, the following implementations could also work:
// assign z = (x && y) || (!x && !y); // Direct implementation of the logic described
// assign z = x == y; // In Verilog, == is the equality operator, which effectively does the same as XNOR for single-bit values

endmodule