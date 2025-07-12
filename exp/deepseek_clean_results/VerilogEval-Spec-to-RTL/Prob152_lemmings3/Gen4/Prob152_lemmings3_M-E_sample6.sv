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
    // State encoding (one-hot style)
    parameter [2:0] 
        WALK_L = 3'b001,
        WALK_R = 3'b010,
        FALL   = 3'b100,
        DIG_L  = 3'b101,
        DIG_R  = 3'b110;
    
    reg [2:0] state, next_state;
    reg ground_prev;
    reg [3:0] fall_timer;
    
    // Edge detection
    wire ground_fall = ground_prev & ~ground;
    wire ground_rise = ~ground_prev & ground;
    
    // State transition logic
    always @(*) begin
        next_state = state;
        
        case (state)
            WALK_L: begin
                if (ground_fall) next_state = FALL;
                else if (dig & ground) next_state = DIG_L;
                else if (bump_left) next_state = WALK_R;
            end
            WALK_R: begin
                if (ground_fall) next_state = FALL;
                else if (dig & ground) next_state = DIG_R;
                else if (bump_right) next_state = WALK_L;
            end
            FALL: begin
                if (ground_rise && fall_timer > 0) begin
                    next_state = (state[0]) ? WALK_L : WALK_R;  // Restore previous direction
                end
            end
            DIG_L: begin
                if (ground_fall) next_state = FALL;
            end
            DIG_R: begin
                if (ground_fall) next_state = FALL;
            end
        endcase
    end
    
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            ground_prev <= 1'b1;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            ground_prev <= ground;
            
            // Update fall timer
            if (state == FALL) begin
                fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK_L) | (state == DIG_L);
    assign walk_right = (state == WALK_R) | (state == DIG_R);
    assign aaah = (state == FALL);
    assign digging = state[2] & ~state[1];  // DIG_L or DIG_R
    
endmodule