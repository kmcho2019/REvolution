module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x, y,  // Group related outputs
    output z
);
    // Group related assignments with clear spacing
    assign w = a;
    assign x = b, y = b;  // Duplicate b connection
    assign z = c;
endmodule