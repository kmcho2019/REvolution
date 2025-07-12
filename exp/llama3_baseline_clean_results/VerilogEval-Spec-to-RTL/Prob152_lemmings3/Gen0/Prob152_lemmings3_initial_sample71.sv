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

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    // Default values
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    next_state = state;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                // No change
            end
        end

        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                // No change
            end
        end

        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                // Resume walking in the same direction as before the fall
                if (bump_left && bump_right) begin
                    // Still switch directions
                    if (state == WALK_LEFT) begin
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    // No change
                    if (state == WALK_LEFT) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end
        end

        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

endmodule