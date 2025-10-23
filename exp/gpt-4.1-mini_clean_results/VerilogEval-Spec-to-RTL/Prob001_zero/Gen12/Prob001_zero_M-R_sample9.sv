module TopModule(output zero);
    wire const_zero;
    assign const_zero = 1'b0;
    assign zero = const_zero;
endmodule