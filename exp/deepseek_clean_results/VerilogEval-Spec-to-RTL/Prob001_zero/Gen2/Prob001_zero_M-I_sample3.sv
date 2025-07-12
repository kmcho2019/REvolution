module TopModule (
    output zero
);
    // Purpose: Constant LOW output
    parameter CONST_ZERO = 1'b0;
    assign zero = CONST_ZERO;
endmodule