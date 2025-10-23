module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x == y);  // Optimal implementation - no improvements possible
endmodule