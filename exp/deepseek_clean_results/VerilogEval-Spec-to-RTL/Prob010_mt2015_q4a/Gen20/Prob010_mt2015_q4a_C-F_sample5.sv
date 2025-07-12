module TopModule (
    input x,
    input y,
    output z
);
    // Optimal fused implementation
    assign z = x & ~y;
endmodule