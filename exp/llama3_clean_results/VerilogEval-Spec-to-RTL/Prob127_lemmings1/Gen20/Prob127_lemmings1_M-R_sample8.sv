module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

logic state; // 1: walking left, 0: walking right

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Initialize state to walking left
    end else begin
        if (bump_left && !bump_right) begin
            state <= 1'b0; // Walk right
        end else if (bump_right && !bump_left) begin
            state <= 1'b1; // Walk left
        end else if (bump_left && bump_right) begin
            state <= ~state; // Toggle state
        end
    end
    // Output logic
    walk_left = state;
    walk_right = ~state;
end

endmodule