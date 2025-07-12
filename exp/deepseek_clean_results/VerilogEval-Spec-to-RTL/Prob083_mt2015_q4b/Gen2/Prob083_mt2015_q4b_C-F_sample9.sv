module TopModule (
    input x,
    input y,
    output z
);
    assign z = x ~^ y;  // XNOR operation: z=1 when x equals y, 0 otherwise
endmodule