module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state; // 0: WALK_LEFT, 1: WALK_RIGHT

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to WALK_LEFT
        walk_left <= 1;
        walk_right <= 0;
    end else begin
        case (state)
            0: begin // WALK_LEFT
                walk_left <= 1;
                walk_right <= 0;
                if (bump_left) begin
                    state <= 1; // switch to WALK_RIGHT
                end
            end
            1: begin // WALK_RIGHT
                walk_left <= 0;
                walk_right <= 1;
                if (bump_right) begin
                    state <= 0; // switch to WALK_LEFT
                end
            end
        endcase
        // if bumped on both sides, still switch directions
        if (bump_left && bump_right) begin
            state <= ~state;
        end
    end
end

endmodule