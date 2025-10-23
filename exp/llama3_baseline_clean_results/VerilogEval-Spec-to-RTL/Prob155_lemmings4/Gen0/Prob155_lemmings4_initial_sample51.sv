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
typedef enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state_t;

// Current state and next state
state_t state, next_state;
logic [5:0] fall_count;

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
        SPLATTERED: begin
            // All outputs are 0
        end
    endcase
end

// Next state logic
always_comb begin
    next_state = state;

    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_state = (bump_left) ? WALK_RIGHT : WALK_LEFT;
                if (bump_left && bump_right) begin
                    next_state = WALK_RIGHT;
                end
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_state = (bump_right) ? WALK_LEFT : WALK_RIGHT;
                if (bump_left && bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
                end
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            // Stay in this state forever
        end
    endcase
end

// Update state and fall count
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_count <= fall_count + 1;
        end else begin
            fall_count <= 0;
        end
    end
end

endmodule