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

    // Define states
    enum logic [2:0] {WALKING_LEFT, WALKING_RIGHT, FALLING, DIGGING, DEAD} state, next_state;

    // Define counters
    logic [5:0] fall_counter;
    logic walking_direction;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING_LEFT;
            fall_counter <= 0;
            walking_direction <= 1'b1;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        else begin
            state <= next_state;
            fall_counter <= fall_counter + (state == FALLING) ? 1 : 0;
            walk_left <= (state == WALKING_LEFT) ? 1'b1 : 1'b0;
            walk_right <= (state == WALKING_RIGHT) ? 1'b1 : 1'b0;
            aaah <= (state == FALLING) ? 1'b1 : 1'b0;
            digging <= (state == DIGGING) ? 1'b1 : 1'b0;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            WALKING_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end
                else if (dig) begin
                    next_state = DIGGING;
                    walking_direction = 1'b1;
                end
                else if (bump_left) begin
                    next_state = WALKING_RIGHT;
                end
                else if (bump_right) begin
                    next_state = WALKING_LEFT;
                end
            end
            WALKING_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end
                else if (dig) begin
                    next_state = DIGGING;
                    walking_direction = 1'b0;
                end
                else if (bump_left) begin
                    next_state = WALKING_LEFT;
                end
                else if (bump_right) begin
                    next_state = WALKING_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = DEAD;
                    end
                    else begin
                        next_state = walking_direction ? WALKING_LEFT : WALKING_RIGHT;
                    end
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end
            end
            DEAD: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end

endmodule