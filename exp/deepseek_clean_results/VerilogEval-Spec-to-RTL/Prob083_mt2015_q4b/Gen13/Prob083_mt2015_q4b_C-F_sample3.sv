module TopModule (
    input x,
    input y,
    output z
);
    // z is 1 when x and y are equal (XNOR function)
    assign z = x ~^ y;
endmodule