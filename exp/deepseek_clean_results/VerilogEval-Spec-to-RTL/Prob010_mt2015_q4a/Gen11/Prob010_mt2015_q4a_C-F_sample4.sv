module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;  // Direct implementation matching specification
endmodule