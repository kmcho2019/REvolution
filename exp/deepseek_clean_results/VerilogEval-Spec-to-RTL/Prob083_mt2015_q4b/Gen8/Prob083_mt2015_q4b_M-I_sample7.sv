module TopModule (
    input x,
    input y,
    output z
);
    // Output is 1 when inputs are equal (XNOR operation)
    // Most efficient implementation: direct equality check
    assign z = (x == y);
endmodule