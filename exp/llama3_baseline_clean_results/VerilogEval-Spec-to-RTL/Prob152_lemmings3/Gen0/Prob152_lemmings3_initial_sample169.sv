module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
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

// Variable to keep track of the Lemming's direction before it starts falling or digging
logic [1:0] prev_direction;

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
    endcase
end

// State machine logic
always_comb begin
    next_state = state;
    
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
                prev_direction = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else if (dig && ground) begin
                next_state = DIGGING;
                prev_direction = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
                prev_direction = WALK_RIGHT;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (dig && ground) begin
                next_state = DIGGING;
                prev_direction = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = prev_direction;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_direction <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule