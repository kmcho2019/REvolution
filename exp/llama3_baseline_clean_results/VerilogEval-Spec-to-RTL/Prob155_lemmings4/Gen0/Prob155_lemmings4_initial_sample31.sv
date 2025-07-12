module TopModule(
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

// Define states
enum logic [2:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Counter to track falling cycles
logic [4:0] falling_counter;

// Reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        falling_counter <= 5'd0;
    end else begin
        state <= next_state;
        if (state == FALLING)
            falling_counter <= falling_counter + 1'd1;
        else
            falling_counter <= 5'd0;
    end
end

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                // Do nothing, already walking left
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else if (bump_left) begin
                // Do nothing, already walking right
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            if (ground) begin
                if (falling_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else if (state == FALLING && (bump_left || bump_right)) begin
                    // Ignore bump while falling
                    if (state == IDLE_LEFT)
                        next_state = IDLE_LEFT;
                    else
                        next_state = IDLE_RIGHT;
                end else if (state == IDLE_LEFT)
                    next_state = IDLE_LEFT;
                else
                    next_state = IDLE_RIGHT;
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

// Output logic
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
        end
        IDLE_RIGHT: begin
            walk_right = 1'b1;
        end
        FALLING: begin
            aaah = 1'b1;
        end
        DIGGING: begin
            digging = 1'b1;
        end
        SPLATTERED: begin
            // All outputs are 0
        end
    endcase
end

endmodule