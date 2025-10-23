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

    typedef enum logic [1:0] {
        WALK,
        FALL,
        DIG,
        SPLAT
    } state_t;

    state_t state, next_state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL) begin
                fall_counter <= (next_state == FALL) ? fall_counter + 1 : 0;
            end
            
            // Update direction when walking or changing due to bump
            if (state == WALK && next_state == WALK) begin
                if (bump_left && !bump_right) direction <= 1;
                if (bump_right && !bump_left) direction <= 0;
                if (bump_left && bump_right) direction <= ~direction;
            end
        end
    end

    // Next state logic with clear priority
    always @(*) begin
        case (state)
            WALK: begin
                if (!ground)          next_state = FALL;
                else if (dig)         next_state = DIG;
                else                 next_state = WALK;
            end
            
            FALL: begin
                if (ground) begin
                    next_state = (fall_counter >= 20) ? SPLAT : WALK;
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (!ground)         next_state = FALL;
                else                 next_state = DIG;
            end
            
            SPLAT:                  next_state = SPLAT;
            default:                next_state = WALK;
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK) & ~direction & ~aaah;
    assign walk_right = (state == WALK) & direction & ~aaah;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule