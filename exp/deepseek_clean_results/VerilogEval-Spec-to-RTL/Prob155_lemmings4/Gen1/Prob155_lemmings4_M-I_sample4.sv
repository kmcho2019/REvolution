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

    state_t state, next_state;
    reg [4:0] fall_counter;
    reg dir_reg;  // 0=left, 1=right

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
            dir_reg <= 0;  // Start walking left
        end else begin
            state <= next_state;
            
            // Update fall counter and direction register
            if (state == FALL) begin
                if (ground) begin
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end else begin
                fall_counter <= 0;
                // Update direction register when walking
                if (state == WALK_LEFT) dir_reg <= 0;
                if (state == WALK_RIGHT) dir_reg <= 1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            
            WALK_RIGHT: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            
            FALL: begin
                if (ground) begin
                    if (fall_counter >= 20) begin
                        next_state = SPLAT;
                    end else begin
                        // Return to previous walking direction
                        next_state = dir_reg ? WALK_RIGHT : WALK_LEFT;
                    end
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG;
                end
            end
            
            SPLAT: begin
                next_state = SPLAT;
            end
            
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore style)
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule