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

    // States
    parameter WALK = 2'd0;
    parameter FALL = 2'd1;
    parameter DIG = 2'd2;
    parameter SPLAT = 2'd3;
    
    reg [1:0] state, next_state;
    reg dir;  // 0=left, 1=right
    reg [4:0] fall_counter;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 0;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter only during FALL state
            if (state == FALL) begin
                if (next_state != FALL)
                    fall_counter <= 0;
                else
                    fall_counter <= fall_counter + 1;
            end
            
            // Update direction only in WALK state when not transitioning to FALL/DIG
            if (state == WALK && next_state == WALK) begin
                if (bump_left) dir <= 1;
                else if (bump_right) dir <= 0;
            end
        end
    end

    // Next state logic with proper priorities
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground)          next_state = FALL;    // Highest priority
                else if (dig)         next_state = DIG;     // Next priority
                else                 next_state = WALK;     // Default
            end
            
            FALL: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SPLAT : WALK;
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (~ground)         next_state = FALL;
                else                 next_state = DIG;
            end
            
            SPLAT:                  next_state = SPLAT;
            
            default:                next_state = WALK;
        endcase
    end

    // Output logic - simplified
    assign walk_left = (state == WALK) & ~dir & (state != SPLAT);
    assign walk_right = (state == WALK) & dir & (state != SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule