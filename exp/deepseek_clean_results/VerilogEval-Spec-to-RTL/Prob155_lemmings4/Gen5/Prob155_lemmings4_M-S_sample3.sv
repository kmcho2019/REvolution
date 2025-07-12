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

    // Combined state encoding
    typedef enum logic [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALL,
        DIG,
        SPLAT
    } state_t;
    
    state_t state, next_state;
    reg [4:0] fall_timer;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update fall timer
            if (state == FALL) begin
                fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
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
                    if (fall_timer > 20) begin
                        next_state = SPLAT;
                    end else begin
                        // Return to previous walking direction
                        next_state = (fall_timer == 0) ? state : 
                                    (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
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

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule