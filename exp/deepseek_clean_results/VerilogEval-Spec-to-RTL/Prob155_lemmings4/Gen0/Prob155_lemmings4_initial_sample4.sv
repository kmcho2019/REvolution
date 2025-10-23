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

    state_t current_state, next_state;
    reg [4:0] fall_counter;
    reg saved_direction; // 0=left, 1=right

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
            saved_direction <= 0;
        end else begin
            current_state <= next_state;
            
            // Update fall counter
            if (current_state == FALLING) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (~ground) begin
                    next_state = FALLING;
                    saved_direction = 0;
                end else if (dig) begin
                    next_state = DIGGING;
                    saved_direction = 0;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            
            WALK_RIGHT: begin
                if (~ground) begin
                    next_state = FALLING;
                    saved_direction = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    saved_direction = 1;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = saved_direction ? WALK_RIGHT : WALK_LEFT;
                    end
                end else begin
                    next_state = FALLING;
                end
            end
            
            DIGGING: begin
                if (~ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            
            SPLATTERED: begin
                next_state = SPLATTERED;
            end
            
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore machine)
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = (current_state == FALLING);
    assign digging = (current_state == DIGGING);

endmodule