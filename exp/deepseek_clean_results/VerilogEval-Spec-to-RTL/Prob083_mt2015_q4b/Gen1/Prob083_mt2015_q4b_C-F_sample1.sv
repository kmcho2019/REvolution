module TopModule (
    input x,
    input y,
    output z
);
    // Output is 1 when inputs are equal (XNOR function)
    assign z = ~(x ^ y);
endmodule