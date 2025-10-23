module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // LEFT state
    end else begin
        state <= next_state;
    end
end

always_comb begin
    if (bump_left && bump_right) begin
        next_state = ~state; // Switch direction
    end else if (bump_left) begin
        next_state = 1'b1; // RIGHT state
    end else if (bump_right) begin
        next_state = 1'b0; // LEFT state
    end else begin
        next_state = state; // Stay in the same state
    end
end

always_comb begin
    walk_left = ~state;
    walk_right = state;
end

endmodule