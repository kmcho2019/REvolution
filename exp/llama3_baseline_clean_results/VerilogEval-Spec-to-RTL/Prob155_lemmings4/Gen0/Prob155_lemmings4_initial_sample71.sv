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

// Define the states of the finite state machine
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Define the direction of the Lemming before it started falling or digging
logic [0:0] was_walking_left;

// Define a counter to keep track of how long the Lemming has been falling
logic [5:0] falling_counter;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        falling_counter <= 6'd0;
        was_walking_left <= 1'b1;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            if (ground) begin
                falling_counter <= 6'd0;
            end else begin
                falling_counter <= falling_counter + 1;
            end
        end else begin
            falling_counter <= 6'd0;
        end
        if ((state == WALK_LEFT || state == WALK_RIGHT) && ground && dig) begin
            was_walking_left <= state == WALK_LEFT;
        end
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                // Do nothing
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                // Do nothing
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (falling_counter > 6'd20) begin
                    next_state = SPLATTERED;
                end else if (was_walking_left) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            // Do nothing
        end
    endcase
end

endmodule