module TopModule (
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
    typedef enum logic [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALL_LEFT,
        FALL_RIGHT,
        DIG_LEFT,
        DIG_RIGHT,
        SPLAT
    } state_t;

    state_t state, next_state;
    reg [4:0] fall_counter;  // Enough to count up to 20

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                if (!ground) begin
                    fall_counter <= fall_counter + 1;
                end else begin
                    fall_counter <= 0;
                end
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    next_state = DIG_LEFT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            
            FALL_LEFT: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end else begin
                    next_state = FALL_LEFT;
                end
            end
            
            FALL_RIGHT: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = FALL_RIGHT;
                end
            end
            
            DIG_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else begin
                    next_state = DIG_LEFT;
                end
            end
            
            DIG_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else begin
                    next_state = DIG_RIGHT;
                end
            end
            
            SPLAT: begin
                next_state = SPLAT;  // Stay in splat forever
            end
            
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Output logic (Moore style - outputs depend only on current state)
    assign walk_left = (state == WALK_LEFT || state == DIG_LEFT);
    assign walk_right = (state == WALK_RIGHT || state == DIG_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule