module TopModule(
    output zero
);
    reg zero_reg = 1'b0;
    assign zero = zero_reg;
endmodule