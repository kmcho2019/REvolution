module TopModule (
    input x,
    input y,
    output z
);
    // z = (x XOR y) AND x = x AND NOT y
    assign z = x & ~y;
endmodule