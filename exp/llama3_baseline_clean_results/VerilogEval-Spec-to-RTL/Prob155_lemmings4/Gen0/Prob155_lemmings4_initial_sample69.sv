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
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Define the counter for falling
logic [5:0] fall_counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 6'd0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 6'd1;
        end else begin
            fall_counter <= 6'd0;
        end
    end
end

always_comb begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 6'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    // Restore previous walking direction
                    if (next_state == WALK_LEFT) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Determine the output signals based on the current state
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
        end
        WALK_RIGHT: begin
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
        default: begin
            walk_left = 1'b1;
        end
    endcase
end

endmodule