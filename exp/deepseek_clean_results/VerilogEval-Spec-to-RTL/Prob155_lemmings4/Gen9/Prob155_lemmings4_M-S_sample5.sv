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
    parameter WALK_L = 2'd0;
    parameter WALK_R = 2'd1;
    parameter DIG    = 2'd2;
    parameter FALL   = 2'd3;
    parameter SPLAT  = 3'd4;

    reg [2:0] state, next_state;
    reg [4:0] fall_counter;
    reg walking_left;  // Tracks walking direction

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_counter <= 0;
            walking_left <= 1;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL && !ground)
                fall_counter <= fall_counter + 1;
            else
                fall_counter <= 0;
            
            // Track walking direction
            if (next_state == WALK_L) walking_left <= 1;
            if (next_state == WALK_R) walking_left <= 0;
        end
    end

    // Next state logic with clear priorities
    always @(*) begin
        case (state)
            WALK_L, WALK_R: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else if ((state == WALK_L && bump_left) || 
                         (state == WALK_R && bump_right))
                    next_state = (state == WALK_L) ? WALK_R : WALK_L;
                else
                    next_state = state;
            end
            
            DIG: begin
                next_state = (!ground) ? FALL : DIG;
            end
            
            FALL: begin
                if (ground)
                    next_state = (fall_counter > 20) ? SPLAT : 
                                (walking_left ? WALK_L : WALK_R);
                else
                    next_state = FALL;
            end
            
            SPLAT: begin
                next_state = SPLAT;
            end
            
            default: next_state = WALK_L;
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL || (state == SPLAT && fall_counter > 20));
    assign digging = (state == DIG);

endmodule