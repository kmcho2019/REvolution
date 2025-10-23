module TopModule (
    input x,
    input y,
    output z
);
    assign z = x ~^ y;  // Explicit XNOR operation for maximum clarity
endmodule