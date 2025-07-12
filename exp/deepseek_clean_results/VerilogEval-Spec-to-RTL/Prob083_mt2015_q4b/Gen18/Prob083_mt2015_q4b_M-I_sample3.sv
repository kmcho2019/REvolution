module TopModule (
    input x,
    input y,
    output z
);
    // Output is high when inputs are equal (XNOR)
    wire z = ~(x ^ y);  // Alternative XNOR implementation
endmodule