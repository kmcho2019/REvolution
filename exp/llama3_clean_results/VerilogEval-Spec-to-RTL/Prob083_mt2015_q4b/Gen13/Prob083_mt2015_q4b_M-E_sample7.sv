module TopModule(
    input x,
    input y,
    output z
);
    // The output z is high when both x and y are high, or when both x and y are low.
    // This logic is represented by the expression: (x and y) or (not x and not y).
    assign z = (x & y) | (!x & !y);
endmodule