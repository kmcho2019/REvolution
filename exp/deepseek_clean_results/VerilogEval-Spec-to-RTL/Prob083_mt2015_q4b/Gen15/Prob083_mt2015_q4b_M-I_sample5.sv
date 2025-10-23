module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x == y);  // Clearer expression of XNOR using equality operator
endmodule