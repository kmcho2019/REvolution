module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    // Main states
    parameter LEFT  = 1'b0;
    parameter RIGHT = 1'b1;
    parameter FALL  = 1'b1; // Same bit as RIGHT but differentiated by aaah
    
    reg state;      // Current state (LEFT/RIGHT)
    reg is_falling; // Falling state indicator
    reg shadow_dir; // Remembers direction during fall
    
    // Next state logic
    always @(*) begin
        if (!ground) begin
            // Enter falling state
            is_falling = 1'b1;
            shadow_dir = state; // Remember current direction
        end else if (is_falling) begin
            // Exit falling state
            is_falling = 1'b0;
        end else begin
            // Normal walking state transitions
            case (state)
                LEFT:  state = bump_left ? RIGHT : LEFT;
                RIGHT: state = bump_right ? LEFT : RIGHT;
            endcase
        end
    end
    
    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            is_falling <= 1'b0;
            shadow_dir <= LEFT;
        end else begin
            if (!ground) begin
                is_falling <= 1'b1;
                shadow_dir <= state;
            end else if (is_falling) begin
                is_falling <= 1'b0;
            end else begin
                state <= (state == LEFT) ? 
                        (bump_left ? RIGHT : LEFT) : 
                        (bump_right ? LEFT : RIGHT);
            end
        end
    end
    
    // Output logic
    assign walk_left  = !is_falling && (state == LEFT);
    assign walk_right = !is_falling && (state == RIGHT);
    assign aaah       = is_falling;
    
endmodule