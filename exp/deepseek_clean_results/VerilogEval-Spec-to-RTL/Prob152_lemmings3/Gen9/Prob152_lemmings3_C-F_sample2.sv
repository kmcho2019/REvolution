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
    // State encoding
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    
    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    
    // Optimized state transition logic with clear priorities
    always @(*) begin
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
                        2'b10: next_direction = 1'b1; // Bump left → go right
                        2'b01: next_direction = 1'b0; // Bump right → go left
                        default: ; // No change
                    endcase
                end
            end
            
            FALL: begin
                if (ground) next_state = WALK; // Return to walking
            end
            
            DIG: begin
                if (~ground) next_state = FALL; // Start falling
            end
        endcase
    end
    
    // State register with optimized updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // Start walking left
        end else begin
            state <= next_state;
            // Only update direction when in WALK state
            if (state == WALK) direction <= next_direction;
        end
    end
    
    // Minimal output logic
    assign walk_left  = (state == WALK) && ~direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);
    
endmodule