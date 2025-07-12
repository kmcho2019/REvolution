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
        FALL_LEFT,
        FALL_RIGHT,
        DIG_LEFT,
        DIG_RIGHT,
        SPLAT
    } state_t;
    
    state_t state, next_state;
    reg [4:0] fall_timer;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= state_t'(WALK_LEFT);
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update fall timer
            if ((state == FALL_LEFT) || (state == FALL_RIGHT)) begin
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
                    next_state = state_t'(FALL_LEFT);
                end else if (dig) begin
                    next_state = state_t'(DIG_LEFT);
                end else if (bump_left) begin
                    next_state = state_t'(WALK_RIGHT);
                end else begin
                    next_state = state_t'(WALK_LEFT);
                end
            end
            
            WALK_RIGHT: begin
                if (~ground) begin
                    next_state = state_t'(FALL_RIGHT);
                end else if (dig) begin
                    next_state = state_t'(DIG_RIGHT);
                end else if (bump_right) begin
                    next_state = state_t'(WALK_LEFT);
                end else begin
                    next_state = state_t'(WALK_RIGHT);
                end
            end
            
            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    if (fall_timer > 20) begin
                        next_state = state_t'(SPLAT);
                    end else if (state == FALL_LEFT) begin
                        next_state = state_t'(WALK_LEFT);
                    end else begin
                        next_state = state_t'(WALK_RIGHT);
                    end
                end else begin
                    next_state = state;
                end
            end
            
            DIG_LEFT: begin
                if (~ground) begin
                    next_state = state_t'(FALL_LEFT);
                end else begin
                    next_state = state_t'(DIG_LEFT);
                end
            end
            
            DIG_RIGHT: begin
                if (~ground) begin
                    next_state = state_t'(FALL_RIGHT);
                end else begin
                    next_state = state_t'(DIG_RIGHT);
                end
            end
            
            SPLAT: begin
                next_state = state_t'(SPLAT);
            end
            
            default: next_state = state_t'(WALK_LEFT);
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = ((state == FALL_LEFT) || (state == FALL_RIGHT));
    assign digging = ((state == DIG_LEFT) || (state == DIG_RIGHT));

endmodule