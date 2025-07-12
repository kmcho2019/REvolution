module TopModule #(
    parameter INVERT = 0  // 0 = direct, 1 = inverted
) (
    input in,
    output out
);
    assign out = INVERT ? ~in : in;
endmodule