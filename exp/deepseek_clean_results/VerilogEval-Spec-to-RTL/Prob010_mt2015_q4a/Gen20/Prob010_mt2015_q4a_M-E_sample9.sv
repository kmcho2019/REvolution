module TopModule (
    input x,
    input y,
    output z
);
    // Implement as 2:1 MUX
    // select = x
    // in0 = 0 (when x=0)
    // in1 = ~y (when x=1)
    assign z = x ? ~y : 1'b0;
endmodule