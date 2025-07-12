module TopModule(
    input x,
    input y,
    output z
);
    assign z = y;  // Entire system simplifies to output y directly
endmodule