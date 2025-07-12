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
        FALL,
        DIG,
        SPLAT
    } state_t;

    state_t current_state, next_state;
    reg [4:0] fall_counter;  // Need to count up to 20 (5 bits)
    reg walking_left;  // Remember walking direction during fall/dig

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
            walking_left <= 1;
        end else begin
            current_state <= next_state;
            
            // Update fall counter
            if (current_state == FALL) begin
                if (next_state == FALL)
                    fall_counter <= fall_counter + 1;
                else
                    fall_counter <= 0;
            end else begin
                fall_counter <= 0;
            end
            
            // Remember walking direction
            if (current_state == WALK_LEFT || current_state == WALK_RIGHT)
                walking_left <= (current_state == WALK_LEFT);
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            
            FALL: begin
                if (ground) begin
                    if (fall_counter > 20)
                        next_state = SPLAT;
                    else if (walking_left)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else
                    next_state = FALL;
            end
            
            DIG: begin
                if (!ground)
                    next_state = FALL;
                else
                    next_state = DIG;
            end
            
            SPLAT: begin
                next_state = SPLAT;  // Stay here forever
            end
            
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore style)
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = (current_state == FALL);
    assign digging = (current_state == DIG);

endmodule