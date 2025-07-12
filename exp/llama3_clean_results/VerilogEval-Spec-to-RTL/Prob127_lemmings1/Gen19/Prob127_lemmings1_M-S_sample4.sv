module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

reg state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Initialize state to walking left
    end else begin
        if (bump_left && !bump_right) begin
            state <= 1'b0; // Switch to walking right
        end else if (!bump_left && bump_right) begin
            state <= 1'b1; // Switch to walking left
        end else if (bump_left && bump_right) begin
            state <= ~state; // Switch direction
        end
    end
end

always_comb begin
    walk_left = state;
    walk_right = ~state;
end

endmodule