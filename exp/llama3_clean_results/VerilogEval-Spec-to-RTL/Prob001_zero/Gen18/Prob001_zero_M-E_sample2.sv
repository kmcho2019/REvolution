module ConstantOutput #(
    parameter bit OUTPUT_VALUE = 1'b0
) (
    output zero
);
    assign zero = OUTPUT_VALUE;
endmodule

module TopModule (
    output zero
);
    ConstantOutput #(.OUTPUT_VALUE(1'b0)) u_constant_output (
        .zero(zero)
    );
endmodule