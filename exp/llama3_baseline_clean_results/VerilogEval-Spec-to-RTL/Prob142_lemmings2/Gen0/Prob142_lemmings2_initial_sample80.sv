module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// Define the states
enum {WALK_LEFT, WALK_RIGHT, FALLING} state, next_state;
reg last_walk_direction; // Track the last walking direction before falling

// State transition logic
always @(*) begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // No change
            end
        end
        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT; // No change
            end
        end
        FALLING: begin
            if (ground) begin
                if (last_walk_direction) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
        end
    endcase
end

// Output logic
always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
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
    endcase
end

// Update the state on positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        last_walk_direction <= 1; // Last walking direction was left
    end else begin
        state <= next_state;
        if (state == WALK_LEFT) begin
            last_walk_direction <= 1; // Last walking direction is left
        end else if (state == WALK_RIGHT) begin
            last_walk_direction <= 0; // Last walking direction is right
        end
    end
end

endmodule