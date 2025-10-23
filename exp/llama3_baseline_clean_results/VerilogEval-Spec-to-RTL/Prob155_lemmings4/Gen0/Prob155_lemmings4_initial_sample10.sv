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

// Define the states of the state machine
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Keep track of the number of clock cycles the Lemming has been falling
reg [5:0] fall_count;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
    end else begin
        state <= next_state;
        fall_count <= (state == FALLING) ? fall_count + 1 : 0;
    end
end

// Combinational logic
always @(*) begin
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
                aaah = 1;
            end else if (dig) begin
                next_state = DIGGING;
                digging = 1;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
            walk_left = 1;
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
                aaah = 1;
            end else if (dig) begin
                next_state = DIGGING;
                digging = 1;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end
            walk_right = 1;
        end
        FALLING: begin
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    // Check if we were walking left or right before falling
                    if (bump_left && bump_right) begin
                        // Both bumps, so we keep the same direction
                        if (dig) begin
                            next_state = DIGGING;
                            digging = 1;
                        end else begin
                            next_state = WALK_LEFT;
                            walk_left = 1;
                        end
                    end else if (bump_left) begin
                        next_state = WALK_RIGHT;
                        walk_right = 1;
                    end else if (bump_right) begin
                        next_state = WALK_LEFT;
                        walk_left = 1;
                    end else if (dig) begin
                        next_state = DIGGING;
                        digging = 1;
                    end else begin
                        // No bumps, so we keep the same direction
                        if (state == WALK_LEFT) begin
                            next_state = WALK_LEFT;
                            walk_left = 1;
                        end else begin
                            next_state = WALK_RIGHT;
                            walk_right = 1;
                        end
                    end
                end
            end else begin
                aaah = 1;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                aaah = 1;
            end else begin
                digging = 1;
            end
        end
        SPLATTERED: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule