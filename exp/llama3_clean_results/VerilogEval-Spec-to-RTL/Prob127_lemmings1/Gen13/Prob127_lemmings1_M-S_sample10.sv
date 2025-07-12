module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // LEFT state
    end else begin
        state <= ~state; // Switch direction if bumped
    end
end

always_comb begin
    if (bump_left || bump_right) begin
        walk_left = ~state;
        walk_right = state;
    end else begin
        walk_left = state;
        walk_right = ~state;
    end
end

endmodule