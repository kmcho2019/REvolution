module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Enum for states
enum logic [1:0] {WALK_LEFT, WALK_RIGHT, FALL_LEFT, FALL_RIGHT} state, next_state;

// Current state logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALL_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // no change
            end else if (bump_left && bump_right) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL_RIGHT;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // no change
            end else if (bump_left && bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALL_LEFT: begin
            if (ground) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = FALL_LEFT;
            end
        end
        FALL_RIGHT: begin
            if (ground) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = FALL_RIGHT;
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Output logic
always_comb begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALL_LEFT, FALL_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule