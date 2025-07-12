module TopModule(
    output one
    );
    reg one_reg;
    assign one = one_reg;
    initial one_reg = 1'b1;
endmodule