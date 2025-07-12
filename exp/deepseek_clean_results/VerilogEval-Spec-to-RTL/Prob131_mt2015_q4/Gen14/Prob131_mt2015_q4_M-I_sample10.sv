module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation combining all logic
    // a_out = x & ~y
    // b_out = ~(x ^ y)
    // z = a_out ^ b_out
    assign z = (x & ~y) ^ ~(x ^ y);
endmodule