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

// Define the states of the FSM
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Define the counter for the number of clock cycles that the Lemming has been falling
logic [5:0] fall_counter;
logic [5:0] next_fall_counter;

// Define the previous walking state
logic [1:0] prev_walking_state;
logic [1:0] next_prev_walking_state;

// Define the FSM's next state logic
always_comb begin
    next_state = state;
    next_fall_counter = fall_counter;
    next_prev_walking_state = prev_walking_state;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;

            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (!ground) begin
                next_state = FALLING;
                next_prev_walking_state = WALK_LEFT;
            end else if (dig) begin
                next_state = DIGGING;
                next_prev_walking_state = WALK_LEFT;
            end
        end

        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;

            if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else if (!ground) begin
                next_state = FALLING;
                next_prev_walking_state = WALK_RIGHT;
            end else if (dig) begin
                next_state = DIGGING;
                next_prev_walking_state = WALK_RIGHT;
            end
        end

        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;

            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = prev_walking_state;
                end
            end else begin
                next_fall_counter = fall_counter + 1;
            end
        end

        DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;

            if (!ground) begin
                next_state = FALLING;
            end
        end

        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end

        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Define the FSM's sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
        prev_walking_state <= WALK_LEFT;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
        prev_walking_state <= next_prev_walking_state;
    end
end

endmodule