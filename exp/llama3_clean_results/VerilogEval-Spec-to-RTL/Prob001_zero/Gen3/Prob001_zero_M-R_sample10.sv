module TopModule(
    output zero
);
    parameter OUTPUT_VALUE = 1'b0;
    reg internal_zero;
    initial internal_zero = OUTPUT_VALUE;
    assign zero = internal_zero;
endmodule