module TopModule (
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Minimal implementation with clear intent
endmodule