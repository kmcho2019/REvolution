module TopModule (
    input x,
    input y,
    output z
);
    wire not_y;
    assign not_y = ~y;
    assign z = ~(~x | not_y);  // Equivalent to x & ~y but using NAND logic
endmodule