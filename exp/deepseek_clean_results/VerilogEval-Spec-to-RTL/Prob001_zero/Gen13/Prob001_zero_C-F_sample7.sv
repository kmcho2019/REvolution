module TopModule (
    output zero
);
    // Constant LOW output with parameterized value for future flexibility
    parameter CONST_VAL = 1'b0;
    assign zero = CONST_VAL;
endmodule