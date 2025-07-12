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

    // Combined state machine
    typedef enum {WALK, FALL, DIG, SPLAT} state_t;
    state_t state, next_state;
    
    reg direction_left;  // 1 for left, 0 for right
    reg [4:0] fall_cycles;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction_left <= 1;
            fall_cycles <= 0;
        end else begin
            state <= next_state;
            
            // Update direction when walking and bumped
            if (state == WALK) begin
                if (bump_left) direction_left <= 0;
                if (bump_right) direction_left <= 1;
            end
            
            // Update fall counter
            if (state == FALL) begin
                fall_cycles <= fall_cycles + 1;
            end else begin
                fall_cycles <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground) next_state = FALL;
                else if (dig) next_state = DIG;
                else next_state = WALK;
            end
            
            FALL: begin
                if (ground) begin
                    next_state = (fall_cycles > 20) ? SPLAT : WALK;
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (~ground) next_state = FALL;
                else next_state = DIG;
            end
            
            SPLAT: next_state = SPLAT;
            
            default: next_state = WALK;
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK) && direction_left && (state != SPLAT);
    assign walk_right = (state == WALK) && ~direction_left && (state != SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule