module TopModule (
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // XNOR operation: most concise implementation
endmodule