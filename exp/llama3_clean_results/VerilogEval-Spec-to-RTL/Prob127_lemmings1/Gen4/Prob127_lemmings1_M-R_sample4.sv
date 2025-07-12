module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state;

// Define sequential logic and next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize to walk left
    end else begin
        if (bump_left && bump_right) begin
            state <= ~state; // Invert state if both bumps are high
        end else if (bump_left && !bump_right) begin
            state <= 1; // Walk right if only left bump
        end else if (!bump_left && bump_right) begin
            state <= 0; // Walk left if only right bump
        end else begin
            state <= state; // No change if no bumps
        end
    end
end

// Define output logic
assign walk_left = ~state;
assign walk_right = state;

endmodule