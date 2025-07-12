module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

logic direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // Initialize direction to WALK_LEFT
    end else begin
        if (bump_left) begin
            direction <= 1'b1; // Switch to WALK_RIGHT if bumped from left
        end else if (bump_right) begin
            direction <= 1'b0; // Switch to WALK_LEFT if bumped from right
        end
    end
end

always_comb begin
    walk_left = ~direction; // WALK_LEFT is active when direction is 0
    walk_right = direction; // WALK_RIGHT is active when direction is 1
end

endmodule