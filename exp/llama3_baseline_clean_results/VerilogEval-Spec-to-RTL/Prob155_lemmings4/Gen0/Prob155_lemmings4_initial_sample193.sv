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

reg [4:0] fall_counter;
reg [1:0] state; // 0: Walking left, 1: Walking right, 2: Falling, 3: Digging
reg [1:0] prev_state; // To keep track of previous state
reg [1:0] direction; // 0: Left, 1: Right

// Initialize the state and direction
initial begin
    state = 0; // Default state: Walking left
    direction = 0; // Default direction: Left
    fall_counter = 0;
    prev_state = 0;
end

// State machine logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state = 0; // Reset to walking left
        direction = 0; // Reset to walking left
        fall_counter = 0;
        prev_state = 0;
    end else begin
        case (state)
            0: begin // Walking left
                if (!ground) begin // If ground disappears, start falling
                    state = 2; // Falling
                    prev_state = 0;
                    fall_counter = 1;
                end else if (dig) begin // If dig signal is high, start digging
                    state = 3; // Digging
                    prev_state = 0;
                end else if (bump_left) begin // If bumped on the left, switch direction
                    state = 1; // Walking right
                    direction = 1;
                end else if (bump_right) begin // If bumped on the right, switch direction
                    state = 0; // Walking left
                    direction = 0;
                end
            end
            1: begin // Walking right
                if (!ground) begin // If ground disappears, start falling
                    state = 2; // Falling
                    prev_state = 1;
                    fall_counter = 1;
                end else if (dig) begin // If dig signal is high, start digging
                    state = 3; // Digging
                    prev_state = 1;
                end else if (bump_left) begin // If bumped on the left, switch direction
                    state = 1; // Walking right
                    direction = 1;
                end else if (bump_right) begin // If bumped on the right, switch direction
                    state = 0; // Walking left
                    direction = 0;
                end
            end
            2: begin // Falling
                if (ground) begin // If ground reappears, resume walking
                    if (fall_counter > 20) begin // If fell for more than 20 clock cycles, splatter
                        state = 4; // Splattered
                    end else begin
                        if (prev_state == 0) begin // Resume walking left
                            state = 0;
                            direction = 0;
                        end else if (prev_state == 1) begin // Resume walking right
                            state = 1;
                            direction = 1;
                        end
                    end
                    fall_counter = 0;
                end else begin
                    fall_counter = fall_counter + 1;
                end
            end
            3: begin // Digging
                if (!ground) begin // If ground disappears, start falling
                    state = 2; // Falling
                    prev_state = 3;
                    fall_counter = 1;
                end
            end
            default: begin // Splattered
                state = 4; // Stay splattered
            end
        endcase
    end
end

// Output logic
assign walk_left = (state == 0 && direction == 0) || (state == 3 && prev_state == 0);
assign walk_right = (state == 1 && direction == 1) || (state == 3 && prev_state == 1);
assign aaah = (state == 2);
assign digging = (state == 3);

endmodule