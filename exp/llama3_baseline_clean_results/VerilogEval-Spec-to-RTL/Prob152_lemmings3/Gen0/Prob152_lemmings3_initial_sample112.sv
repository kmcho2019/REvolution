module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING
} state, next_state;

// Output logic
always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1;
        end
        WALK_RIGHT: begin
            walk_right = 1;
        end
        FALLING: begin
            aaah = 1;
        end
        DIGGING: begin
            digging = 1;
        end
        default: begin
            // Do nothing
        end
    endcase
end

// State transition logic
always_comb begin
    next_state = state;

    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                // No change
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                // No change
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                // If we were walking left before falling, resume walking left
                if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        default: begin
            // Do nothing
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule