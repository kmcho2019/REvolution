module TopModule (
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // XNOR operation: z is 1 when x equals y
endmodule