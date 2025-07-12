module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [0:0] state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // LEFT state
    end else if (bump_left || bump_right) begin
        state <= ~state; // Switch direction
    end
end

always_comb begin
    walk_left = ~state;
    walk_right = state;
end

endmodule