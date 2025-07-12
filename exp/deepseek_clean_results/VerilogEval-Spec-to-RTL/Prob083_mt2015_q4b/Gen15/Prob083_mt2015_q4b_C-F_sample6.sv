module TopModule (
    input x,
    input y,
    output z
);
    // z is high when x and y have the same value (XNOR function)
    assign z = x ~^ y;
endmodule