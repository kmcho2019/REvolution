module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

reg state; // State flip-flop

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // Initialize state to walking left
    end else begin
        if (bump_left && !bump_right) begin
            state <= 1'b1; // Switch to walking right
        end else if (bump_right && !bump_left) begin
            state <= 1'b0; // Switch to walking left
        end else if (bump_left && bump_right) begin
            state <= ~state; // Switch direction
        end
    end
end

assign walk_left = ~state; // Derive output directly from state
assign walk_right = state;

endmodule