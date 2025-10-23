module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] state;

always @(posedge clk) begin
    if (shift_ena) begin
        state <= {data, state[3:1]};
    end else if (count_ena) begin
        state <= state - 1;
    end
end

assign q = state;

endmodule