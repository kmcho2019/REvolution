module TopModule (
    input x,
    input y,
    output z
);
    assign z = x ~^ y;  // This is equivalent to XNOR operation
endmodule