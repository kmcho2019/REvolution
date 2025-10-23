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

    // State definitions
    typedef enum logic [1:0] {
        WALKING,
        FALLING,
        DIGGING,
        SPLATTERED
    } state_t;

    // Direction definitions
    typedef enum logic {
        LEFT,
        RIGHT
    } direction_t;

    // State registers
    state_t current_state, next_state;
    direction_t current_dir, next_dir;
    logic [4:0] fall_timer;

    // Event detection
    wire fall_start = (current_state != FALLING) && !ground;
    wire dig_start = (current_state == WALKING) && ground && dig;
    wire bump_event = (current_state == WALKING) && (bump_left || bump_right);

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALKING;
            current_dir <= LEFT;
            fall_timer <= 0;
        end else begin
            current_state <= next_state;
            current_dir <= next_dir;
            
            // Fall timer logic
            if (current_state == FALLING) begin
                if (ground) begin
                    fall_timer <= 0;
                end else begin
                    fall_timer <= fall_timer + 1;
                end
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state;
        next_dir = current_dir;
        
        case (current_state)
            WALKING: begin
                if (fall_start) begin
                    next_state = FALLING;
                end else if (dig_start) begin
                    next_state = DIGGING;
                end else if (bump_event) begin
                    next_dir = bump_left ? LEFT : RIGHT;
                end
            end
            
            DIGGING: begin
                if (fall_start) begin
                    next_state = FALLING;
                end
            end
            
            FALLING: begin
                if (ground) begin
                    next_state = (fall_timer > 20) ? SPLATTERED : WALKING;
                end
            end
            
            SPLATTERED: begin
                // Stay in splattered state
            end
        endcase
    end

    // Output logic
    assign walk_left = (current_state == WALKING) && (current_dir == LEFT);
    assign walk_right = (current_state == WALKING) && (current_dir == RIGHT);
    assign aaah = (current_state == FALLING);
    assign digging = (current_state == DIGGING);

endmodule