module TopModule #(
    parameter ZERO_VALUE = 1'b0
) (
    output zero
);
    assign zero = ZERO_VALUE;
endmodule