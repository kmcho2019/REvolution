module TopModule (
    output zero
);
    // Constant LOW output with configurable value (default 0)
    parameter LOW_VALUE = 1'b0;
    assign zero = LOW_VALUE;
endmodule