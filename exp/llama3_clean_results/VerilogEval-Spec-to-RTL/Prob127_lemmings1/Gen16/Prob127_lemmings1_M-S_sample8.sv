module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

reg walk_left_reg; // State flip-flop

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left_reg <= 1'b1; // Initialize state to walking left
    end else begin
        if (bump_left && !bump_right) begin
            walk_left_reg <= 1'b0; // Switch to walking right
        end else if (bump_right && !bump_left) begin
            walk_left_reg <= 1'b1; // Switch to walking left
        end else if (bump_left && bump_right) begin
            walk_left_reg <= ~walk_left_reg; // Switch direction
        end
    end
end

assign walk_left = walk_left_reg;
assign walk_right = ~walk_left_reg;

endmodule