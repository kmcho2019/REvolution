module TopModule (
    input x,       // Input signal x
    input y,       // Input signal y
    output z       // Output z = (x XOR y) AND x
);
    // Implementation of boolean function z = (x^y) & x
    assign z = (x ^ y) & x;
endmodule