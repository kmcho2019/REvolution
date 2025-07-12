module TopModule (
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Equivalent to XNOR but using basic operators
endmodule