module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation combining all logic
    assign z = (x & ~y) ^ ~(x ^ y);
endmodule