module TopModule(
    input x,
    input y,
    output z
);
    // Output is high only when x and y are equal (XNOR)
    assign z = ~(x ^ y);
endmodule