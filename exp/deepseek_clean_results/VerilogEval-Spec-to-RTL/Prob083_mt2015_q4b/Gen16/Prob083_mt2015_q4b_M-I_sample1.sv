module TopModule (
    input x,
    input y,
    output z
);
    assign z = x ~^ y;  // Alternative XNOR syntax, functionally identical
endmodule