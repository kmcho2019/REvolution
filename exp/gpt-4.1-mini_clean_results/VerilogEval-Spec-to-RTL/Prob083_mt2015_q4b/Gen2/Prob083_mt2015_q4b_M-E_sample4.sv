module TopModule(
    input x,
    input y,
    output z
);
    wire both_one;
    wire both_zero;

    assign both_one = x & y;      // Both inputs are 1
    assign both_zero = ~(x | y);  // Both inputs are 0

    assign z = both_one | both_zero; // z is high if both are 1 or both are 0
endmodule