module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// Enum to represent the states
enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING
} state, next_state;

// Current walking direction
reg walk_direction;

always @(*) begin
    // Determine the next state and outputs based on the current state and inputs
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
            end else begin
                next_state = WALK_LEFT;
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
            end else begin
                next_state = WALK_RIGHT;
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
            end
        end
        FALLING: begin
            if (ground) begin
                if (walk_direction) begin
                    next_state = WALK_LEFT;
                    walk_left = 1;
                    walk_right = 0;
                end else begin
                    next_state = WALK_RIGHT;
                    walk_left = 0;
                    walk_right = 1;
                end
                aaah = 0;
            end else begin
                next_state = FALLING;
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_direction <= 1;
    end else begin
        state <= next_state;
        if (state == WALK_LEFT) begin
            walk_direction <= 1;
        end else if (state == WALK_RIGHT) begin
            walk_direction <= 0;
        end
    end
end

endmodule