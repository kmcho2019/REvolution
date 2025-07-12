module TopModule(
    output zero
);
    wire const_zero = 1'b0;
    and (zero, const_zero, const_zero);
endmodule