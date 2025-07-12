module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x == y);  // Simplified using equality operator
endmodule