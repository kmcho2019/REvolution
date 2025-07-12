module TopModule(output zero);
    reg zero_reg;
    assign zero = zero_reg;

    initial begin
        zero_reg = 1'b0;
    end
endmodule