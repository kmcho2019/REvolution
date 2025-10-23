module TopModule (
    input x,
    input y,
    output z
);
    // Optimal XNOR implementation using direct operator
    assign z = x ~^ y;
endmodule