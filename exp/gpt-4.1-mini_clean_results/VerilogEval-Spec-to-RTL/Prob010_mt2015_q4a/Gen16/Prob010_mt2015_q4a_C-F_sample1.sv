module TopModule (
    input  x,
    input  y,
    output z
);
    // Implement z = x & ~y directly for optimal power, area, and performance
    assign z = x & ~y;
endmodule