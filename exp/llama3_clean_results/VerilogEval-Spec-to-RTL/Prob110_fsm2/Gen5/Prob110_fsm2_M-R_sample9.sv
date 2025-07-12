module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

reg state; // Using binary encoding for states
reg next_state;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 0; // OFF state
    end else begin
        state <= next_state;
    end
end

assign next_state = (state == 0)? (j? 1 : 0) : (k? 0 : 1);
assign out = state;

endmodule