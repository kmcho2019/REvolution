module TopModule (
    input x,
    input y,
    output z
);
    // MUX implementation where:
    // - select = x
    // - input0 = 0 (when x=0)
    // - input1 = ~y (when x=1)
    assign z = x ? ~y : 1'b0;
endmodule