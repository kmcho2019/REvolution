module TopModule (
    input x,
    input y,
    output z
);
    // Simplified boolean function: z = x AND NOT y
    assign z = x & ~y;
endmodule