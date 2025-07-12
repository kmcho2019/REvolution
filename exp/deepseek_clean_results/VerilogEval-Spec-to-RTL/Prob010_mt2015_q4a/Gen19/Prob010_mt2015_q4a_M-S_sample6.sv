module TopModule (
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Minimal implementation: x AND NOT y
endmodule