module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

// Use assign statements for sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left <= 1'b1; // Initialize state to LEFT
        walk_right <= 1'b0;
    end else begin
        walk_left <= ~(bump_left) && walk_left || bump_right && ~walk_left;
        walk_right <= (bump_left) && ~walk_right || bump_right && walk_right;
    end
end

endmodule