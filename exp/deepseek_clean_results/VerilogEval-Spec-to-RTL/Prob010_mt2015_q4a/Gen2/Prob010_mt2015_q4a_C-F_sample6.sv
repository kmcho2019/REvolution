module TopModule (
    input x,
    input y,
    output z
);
    // Implements boolean function z = (x XOR y) AND x
    assign z = (x ^ y) & x;
endmodule