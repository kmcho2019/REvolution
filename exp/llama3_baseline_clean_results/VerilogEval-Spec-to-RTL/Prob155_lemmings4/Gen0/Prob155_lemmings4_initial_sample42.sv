module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Enum for the states
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Counter for fall time
reg [5:0] fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
    end
end

always @(*) begin
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            if (ground == 0) begin
                next_state = FALLING;
                aaah = 1;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                // no change
            end else if (dig && ground) begin
                next_state = DIGGING;
                digging = 1;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1;
            if (ground == 0) begin
                next_state = FALLING;
                aaah = 1;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                // no change
            end else if (dig && ground) begin
                next_state = DIGGING;
                digging = 1;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground == 1) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if (bump_left) begin
                        next_state = WALK_RIGHT;
                    end else if (bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        // Restore the original walking direction
                        if (walk_left) begin
                            next_state = WALK_LEFT;
                        end else if (walk_right) begin
                            next_state = WALK_RIGHT;
                        end
                    end
                end
            end
        end
        DIGGING: begin
            digging = 1;
            if (ground == 0) begin
                next_state = FALLING;
                aaah = 1;
            end
        end
        SPLATTERED: begin
            // No actions
        end
    endcase
end

endmodule