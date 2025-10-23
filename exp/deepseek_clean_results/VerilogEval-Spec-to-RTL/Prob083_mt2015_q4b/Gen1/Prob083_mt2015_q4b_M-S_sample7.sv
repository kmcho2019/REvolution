module TopModule (
    input x,
    input y,
    output z
);
    assign z = x ~^ y;  // Equivalent XNOR operation using alternative syntax
endmodule