module TopModule (
    input x,
    input y,
    output z
);
    // MUX implementation of XNOR
    assign z = (x == y) ? 1'b1 : 1'b0;
endmodule