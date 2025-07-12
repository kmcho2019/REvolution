module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

always @* begin
    next_state = (state ^ a) | b;
end

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial begin
    state = 1'b0;
end

endmodule