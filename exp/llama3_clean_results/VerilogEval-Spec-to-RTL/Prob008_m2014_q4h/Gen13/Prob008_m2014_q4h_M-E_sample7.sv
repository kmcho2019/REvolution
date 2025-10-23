module TopModule(
    input in,
    output out
);
    wire zero, one;
    assign zero = 1'b0;
    assign one = 1'b1;
    assign out = in? one : zero;
endmodule