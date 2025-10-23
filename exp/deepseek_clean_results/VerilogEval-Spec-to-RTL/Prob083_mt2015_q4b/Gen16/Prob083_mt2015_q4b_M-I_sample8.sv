module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x == y);  // Explicit equality comparison
endmodule