module TopModule #(
    parameter OUTPUT_VALUE = 1'b1
)(
    output one
);

reg internal_signal;

always @(one or OUTPUT_VALUE) begin
    internal_signal = OUTPUT_VALUE;
end

assign one = internal_signal;

endmodule