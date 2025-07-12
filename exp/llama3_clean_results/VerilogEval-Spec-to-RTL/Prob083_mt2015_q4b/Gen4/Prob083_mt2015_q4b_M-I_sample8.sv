// The optimized code
module TopModule(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);
endmodule