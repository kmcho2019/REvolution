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
    parameter [2:0] 
        WALK_L  = 0,
        WALK_R  = 1,
        FALL_L  = 2,
        FALL_R  = 3,
        DIG_L   = 4,
        DIG_R   = 5,
        SPLAT   = 6;
    reg [2:0] state, next_state;

    // Fall timer
    reg [4:0] fall_count;

    // Next state logic
    always @(*) begin
        case (state)
            WALK_L: begin
                if (~ground)          next_state = FALL_L;
                else if (dig)        next_state = DIG_L;
                else if (bump_left)   next_state = WALK_R;
                else                  next_state = WALK_L;
            end
            WALK_R: begin
                if (~ground)          next_state = FALL_R;
                else if (dig)        next_state = DIG_R;
                else if (bump_right)  next_state = WALK_L;
                else                  next_state = WALK_R;
            end
            FALL_L: begin
                if (ground)           next_state = (fall_count > 20) ? SPLAT : WALK_L;
                else                 next_state = FALL_L;
            end
            FALL_R: begin
                if (ground)          next_state = (fall_count > 20) ? SPLAT : WALK_R;
                else                 next_state = FALL_R;
            end
            DIG_L: begin
                if (~ground)         next_state = FALL_L;
                else                 next_state = DIG_L;
            end
            DIG_R: begin
                if (~ground)         next_state = FALL_R;
                else                 next_state = DIG_R;
            end
            SPLAT:                  next_state = SPLAT;
            default:                 next_state = WALK_L;
        endcase
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_count <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL_L || state == FALL_R) begin
                if (~ground) fall_count <= fall_count + 1;
                else fall_count <= 0;
            end else begin
                fall_count <= 0;
            end
        end
    end

    // Outputs
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL_L || state == FALL_R);
    assign digging = (state == DIG_L || state == DIG_R);

endmodule