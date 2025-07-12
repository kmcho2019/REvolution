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
        FALLING,
        DIGGING,
        SPLATTERED
    } state_t;

    state_t state, next_state;
    reg [4:0] fall_counter;  // Need to count up to 20 (5 bits)
    reg direction;  // 0 for left, 1 for right

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 0;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALLING) begin
                if (!ground) begin
                    fall_counter <= fall_counter + 1;
                end else begin
                    fall_counter <= 0;
                end
            end else begin
                fall_counter <= 0;
            end
            
            // Update direction when switching in walking states
            if ((state == WALK_LEFT || state == WALK_RIGHT) && 
                next_state != FALLING && next_state != DIGGING) begin
                if (bump_left && !bump_right) begin
                    direction <= 1;  // switch to right
                end else if (bump_right && !bump_left) begin
                    direction <= 0;  // switch to left
                end else if (bump_left && bump_right) begin
                    direction <= ~direction;  // toggle direction
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_LEFT, WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                end else begin
                    next_state = state;  // stay in current walking state
                end
            end
            
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = direction ? WALK_RIGHT : WALK_LEFT;
                    end
                end else begin
                    next_state = FALLING;
                end
            end
            
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            
            SPLATTERED: begin
                next_state = SPLATTERED;  // stay forever
            end
            
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Output logic (Moore style - outputs depend only on current state)
    assign walk_left = (state == WALK_LEFT) && (state != SPLATTERED);
    assign walk_right = (state == WALK_RIGHT) && (state != SPLATTERED);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule