module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

logic [0:0] direction; // 0 for left, 1 for right

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 0; // initialize direction to left
    end else begin
        if (bump_left) begin
            direction <= 1; // switch to right if bumped on the left
        end else if (bump_right) begin
            direction <= 0; // switch to left if bumped on the right
        end
    end
end

always_comb begin
    case (direction)
        0: begin
            walk_left = 1'b1; // walk left if direction is left
            walk_right = 1'b0;
        end
        1: begin
            walk_left = 1'b0; // walk right if direction is right
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b0; // default to not walking
            walk_right = 1'b0;
        end
    endcase
end

endmodule