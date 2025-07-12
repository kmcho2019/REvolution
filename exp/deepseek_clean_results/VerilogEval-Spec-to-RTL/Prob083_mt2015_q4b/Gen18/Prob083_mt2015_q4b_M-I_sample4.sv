module TopModule (
    input x,
    input y,
    output z
);
    assign z = x ~^ y;  // Direct XNOR operation
endmodule