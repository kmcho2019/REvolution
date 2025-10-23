module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x == y);  // Optimal combination of clarity and functionality
endmodule