module TopModule (
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
typedef enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING
} state_t;

state_t state, next_state;
logic [1:0] direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        direction <= 2'b00; // walking left
    end else begin
        state <= next_state;
        if (ground) begin
            if (state == FALLING) begin
                if (direction == 2'b00) begin
                    state <= WALK_LEFT;
                end else begin
                    state <= WALK_RIGHT;
                end
            end
            if (dig && state != FALLING && state != DIGGING) begin
                if (direction == 2'b00) begin
                    state <= DIGGING;
                end else begin
                    state <= DIGGING;
                end
            end
        end
    end
end

always_comb begin
    case (state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
                direction = 2'b01; // walking right
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                direction = 2'b00; // walking left
            end else if (ground == 1'b0) begin
                next_state = FALLING;
                direction = 2'b00; // walking left
            end else begin
                next_state = WALK_LEFT;
                direction = 2'b00; // walking left
            end
        end
        WALK_RIGHT: begin
            if (bump_left) begin
                next_state = WALK_LEFT;
                direction = 2'b00; // walking left
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
                direction = 2'b01; // walking right
            end else if (ground == 1'b0) begin
                next_state = FALLING;
                direction = 2'b01; // walking right
            end else begin
                next_state = WALK_RIGHT;
                direction = 2'b01; // walking right
            end
        end
        FALLING: begin
            if (ground) begin
                if (direction == 2'b00) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
                if (direction == 2'b00) begin
                    direction = 2'b00; // walking left
                end else begin
                    direction = 2'b01; // walking right
                end
            end else begin
                next_state = DIGGING;
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

always_comb begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING: begin
            if (direction == 2'b00) begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end else begin
                walk_left = 1'b0;
                walk_right = 1'b1;
            end
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule