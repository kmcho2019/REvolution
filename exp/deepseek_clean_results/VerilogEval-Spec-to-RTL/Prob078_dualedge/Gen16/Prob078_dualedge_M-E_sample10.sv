module TopModule (
    input clk,
    input d,
    output q
);

reg state;

always @(posedge clk or negedge clk) begin
    // XOR-based toggle with data input as enable
    state <= d ? (state ^ 1'b1) : state;
end

assign q = state;

endmodule