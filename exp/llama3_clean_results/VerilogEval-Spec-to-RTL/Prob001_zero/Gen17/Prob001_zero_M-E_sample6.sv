module ConstantOutput #(
    parameter OUT_VALUE = 1'b0
) (
    output logic out
);
    assign out = OUT_VALUE;
endmodule

module TopModule (
    output zero
);
    ConstantOutput #(.OUT_VALUE(1'b0)) u_zero (.out(zero));
endmodule