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
    // State encoding with descriptive names
    parameter [1:0] WALK = 2'b00;
    parameter [1:0] FALL = 2'b01;
    parameter [1:0] DIG  = 2'b10;
    
    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    
    // State transition logic with strict priorities
    always @(*) begin
        // Default assignments
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALK: begin
                if (~ground) begin
                    next_state = FALL; // Highest priority: fall
                end else if (dig) begin
                    next_state = DIG;  // Medium priority: dig
                end else begin
                    // Only check bumps if no higher priority
                    case ({bump_left, bump_right})
                        2'b10: next_direction = 1'b1; // Turn right
                        2'b01: next_direction = 1'b0; // Turn left
                        2'b11: next_direction = ~direction; // Reverse direction
                        default: ; // No change
                    endcase
                end
            end
            
            FALL: if (ground) next_state = WALK;
            
            DIG: if (~ground) next_state = FALL;
        endcase
    end
    
    // State register with optimized updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // Start walking left
        end else begin
            state <= next_state;
            // Only update direction when in WALK state and it changed
            if (state == WALK && direction != next_direction) begin
                direction <= next_direction;
            end
        end
    end
    
    // Output logic - purely combinatorial
    assign walk_left  = (state == WALK) && ~direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);
    
endmodule