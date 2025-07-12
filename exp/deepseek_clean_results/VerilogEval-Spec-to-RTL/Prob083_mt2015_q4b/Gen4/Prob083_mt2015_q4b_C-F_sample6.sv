module TopModule (
    input x,
    input y,
    output z
);
    assign z = x ~^ y;  // XNOR: z=1 when x equals y (both 0 or both 1), 0 otherwise
endmodule