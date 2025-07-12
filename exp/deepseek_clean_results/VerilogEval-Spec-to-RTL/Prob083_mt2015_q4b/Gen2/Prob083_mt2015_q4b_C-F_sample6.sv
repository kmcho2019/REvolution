module TopModule (
    input x,
    input y,
    output z
);
    assign z = x ~^ y;  // z=1 when x equals y (XNOR operation)
endmodule