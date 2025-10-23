module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states of the FSM
enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING} state, next_state;

// Initialize the state machine with IDLE_LEFT state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

// Logic to determine the next state and output signals
always @(*) begin
    case(state)
        IDLE_LEFT: begin
            if (ground == 0) begin
                next_state <= FALLING;
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
            end else if (bump_left == 1 || bump_right == 1) begin
                next_state <= IDLE_RIGHT;
                walk_left <= 0;
                walk_right <= 1;
                aaah <= 0;
            end else begin
                next_state <= IDLE_LEFT;
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
            end
        end
        IDLE_RIGHT: begin
            if (ground == 0) begin
                next_state <= FALLING;
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
            end else if (bump_left == 1 || bump_right == 1) begin
                next_state <= IDLE_LEFT;
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
            end else begin
                next_state <= IDLE_RIGHT;
                walk_left <= 0;
                walk_right <= 1;
                aaah <= 0;
            end
        end
        FALLING: begin
            if (ground == 1) begin
                // Restore the previous direction
                if (bump_left == 1 || bump_right == 1) begin
                    // Ignore the bump signals when restoring the previous direction
                    if (state == FALLING && next_state == IDLE_LEFT) begin
                        next_state <= IDLE_LEFT;
                        walk_left <= 1;
                        walk_right <= 0;
                        aaah <= 0;
                    end else begin
                        next_state <= IDLE_RIGHT;
                        walk_left <= 0;
                        walk_right <= 1;
                        aaah <= 0;
                    end
                end else begin
                    // If the Lemming was walking left before falling, restore it to the IDLE_LEFT state
                    if (state == IDLE_LEFT) begin
                        next_state <= IDLE_LEFT;
                        walk_left <= 1;
                        walk_right <= 0;
                        aaah <= 0;
                    // If the Lemming was walking right before falling, restore it to the IDLE_RIGHT state
                    end else begin
                        next_state <= IDLE_RIGHT;
                        walk_left <= 0;
                        walk_right <= 1;
                        aaah <= 0;
                    end
                end
            end else begin
                next_state <= FALLING;
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
            end
        end
    endcase
end

// Drive the output signals
assign walk_left = (state == IDLE_LEFT)? 1 : 0;
assign walk_right = (state == IDLE_RIGHT)? 1 : 0;
assign aaah = (state == FALLING)? 1 : 0;

endmodule