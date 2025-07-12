module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of the logic
    assign z = (x & ~y) ^ ~(x ^ y);
    // Alternative equivalent implementation:
    // assign z = x | ~y;
endmodule