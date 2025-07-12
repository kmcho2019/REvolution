module TopModule(output zero);
    wire const_zero;
    parameter ZERO_VAL = 1'b0;
    assign const_zero = ZERO_VAL;
    assign zero = const_zero;
endmodule