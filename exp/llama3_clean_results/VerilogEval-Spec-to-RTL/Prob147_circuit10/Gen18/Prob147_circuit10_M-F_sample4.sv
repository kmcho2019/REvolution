module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

reg next_state;

assign next_state = (state == 1'b0 && !a && !b) ? 1'b1 : (state == 1'b1 && a && b) ? 1'b0 : state;
assign q = (state == 1'b0) ? b : 1'b1;

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule