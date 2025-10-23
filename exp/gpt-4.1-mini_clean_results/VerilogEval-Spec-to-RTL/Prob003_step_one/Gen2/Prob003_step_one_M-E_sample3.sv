module TopModule #(
    parameter DEFAULT_VALUE = 1'b1
)(
    output wire one
);

wire const_val;
assign const_val = DEFAULT_VALUE;
assign one = const_val;

endmodule