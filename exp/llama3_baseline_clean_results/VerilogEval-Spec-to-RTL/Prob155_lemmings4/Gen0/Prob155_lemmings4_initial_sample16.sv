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
enum logic [2:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Define the counter for falling time
logic [5:0] fall_counter, next_fall_counter;

// Define the previous walking direction
logic prev_walk_left, next_prev_walk_left;

// State logic
always_comb begin
    next_state = state;
    next_fall_counter = fall_counter;
    next_prev_walk_left = prev_walk_left;

    case (state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = prev_walk_left ? WALK_LEFT : WALK_RIGHT;
                end
            end else begin
                next_fall_counter = fall_counter + 1;
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Output logic
always_comb begin
    walk_left = (state == WALK_LEFT) && (state != SPLATTERED);
    walk_right = (state == WALK_RIGHT) && (state != SPLATTERED);
    aaah = (state == FALLING) && (state != SPLATTERED);
    digging = (state == DIGGING) && (state != SPLATTERED);
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
        prev_walk_left <= 1;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
        prev_walk_left <= next_prev_walk_left;
        if (state == WALK_LEFT || state == WALK_RIGHT) begin
            next_prev_walk_left <= (state == WALK_LEFT);
        end
    end
end

endmodule