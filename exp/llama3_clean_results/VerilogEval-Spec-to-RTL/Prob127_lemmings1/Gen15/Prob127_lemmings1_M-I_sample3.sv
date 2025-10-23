module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

reg walk_left_reg; // Using a single bit to represent the state

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left_reg <= 1'b1; // Initialize state to LEFT
    end else begin
        walk_left_reg <= ~(bump_left | bump_right)? walk_left_reg : ~walk_left_reg; // Switch direction on bump
    end
end

assign walk_left = walk_left_reg;
assign walk_right = ~walk_left_reg;

endmodule