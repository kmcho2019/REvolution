// Alternative 1: Using parameter for explicit constant
module TopModule (
    output zero
);
    parameter CONST_ZERO = 1'b0;
    assign zero = CONST_ZERO;
endmodule

// Alternative 2: Most minimal direct wire assignment
module TopModule (
    output zero = 1'b0
);
endmodule