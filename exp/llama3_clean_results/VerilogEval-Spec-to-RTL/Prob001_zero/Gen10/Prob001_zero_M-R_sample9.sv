module TopModule #(
    parameter OUTPUT_VALUE = 1'b0
)(
    output zero
);
    always @(*) begin
        zero = OUTPUT_VALUE;
    end
endmodule