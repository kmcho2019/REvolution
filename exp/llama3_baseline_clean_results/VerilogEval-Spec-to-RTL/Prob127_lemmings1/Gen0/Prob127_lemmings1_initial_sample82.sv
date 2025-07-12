module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg state; // 0: walking left, 1: walking right
reg next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    if (bump_left || bump_right) begin
        next_state = ~state; // switch directions
    end else begin
        next_state = state; // stay in the same direction
    end
end

assign walk_left = ~state; // walking left when state is 0
assign walk_right = state; // walking right when state is 1

endmodule