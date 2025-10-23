module TopModule (
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Minimal implementation using AND-NOT
endmodule