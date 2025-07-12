module TopModule(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y); // XNOR of x and y
endmodule