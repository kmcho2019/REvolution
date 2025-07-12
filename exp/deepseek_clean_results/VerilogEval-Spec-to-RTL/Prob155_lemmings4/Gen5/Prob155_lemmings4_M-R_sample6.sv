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
    parameter LEFT_WALK  = 0;
    parameter RIGHT_WALK = 1;
    parameter LEFT_FALL  = 2;
    parameter RIGHT_FALL = 3;
    parameter LEFT_DIG   = 4;
    parameter RIGHT_DIG  = 5;
    parameter SPLAT      = 6;

    reg [2:0] state, next_state;
    reg [4:0] fall_timer;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT_WALK;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update fall timer
            if (state == LEFT_FALL || state == RIGHT_FALL) begin
                fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Next state logic with explicit priorities
    always @(*) begin
        case (state)
            LEFT_WALK: begin
                if (~ground)          next_state = LEFT_FALL;
                else if (dig)         next_state = LEFT_DIG;
                else if (bump_left)   next_state = RIGHT_WALK;
                else                  next_state = LEFT_WALK;
            end
            
            RIGHT_WALK: begin
                if (~ground)          next_state = RIGHT_FALL;
                else if (dig)         next_state = RIGHT_DIG;
                else if (bump_right)  next_state = LEFT_WALK;
                else                  next_state = RIGHT_WALK;
            end
            
            LEFT_FALL: begin
                if (ground) begin
                    next_state = (fall_timer > 20) ? SPLAT : LEFT_WALK;
                end else begin
                    next_state = LEFT_FALL;
                end
            end
            
            RIGHT_FALL: begin
                if (ground) begin
                    next_state = (fall_timer > 20) ? SPLAT : RIGHT_WALK;
                end else begin
                    next_state = RIGHT_FALL;
                end
            end
            
            LEFT_DIG: begin
                if (~ground)          next_state = LEFT_FALL;
                else                 next_state = LEFT_DIG;
            end
            
            RIGHT_DIG: begin
                if (~ground)          next_state = RIGHT_FALL;
                else                  next_state = RIGHT_DIG;
            end
            
            SPLAT:                   next_state = SPLAT;
            
            default:                 next_state = LEFT_WALK;
        endcase
    end

    // Output logic - direct assignments from state
    assign walk_left  = (state == LEFT_WALK);
    assign walk_right = (state == RIGHT_WALK);
    assign aaah       = (state == LEFT_FALL || state == RIGHT_FALL);
    assign digging    = (state == LEFT_DIG || state == RIGHT_DIG);

endmodule