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
    // One-hot state encoding
    parameter WALK_LEFT  = 3'b100;
    parameter WALK_RIGHT = 3'b010;
    parameter FALL       = 3'b001;
    parameter DIGGING    = 3'b110; // Special case (WALK + DIG)
    
    reg [2:0] state, next_state;
    
    // Hierarchical state transitions
    always @(*) begin
        case (state)
            WALK_LEFT, WALK_RIGHT: begin
                if (~ground) begin
                    next_state = FALL; // Highest priority
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    // Direction change logic
                    if ((state == WALK_LEFT && bump_left) ||
                        (state == WALK_RIGHT && bump_right)) begin
                        next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    end else begin
                        next_state = state; // Maintain direction
                    end
                end
            end
            
            FALL: begin
                next_state = ground ? 
                    ((state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT) : // Restore previous direction
                    FALL;
            end
            
            DIGGING: begin
                next_state = ~ground ? FALL : DIGGING;
            end
            
            default: next_state = WALK_LEFT; // Default to left on reset
        endcase
    end
    
    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end
    
    // Direct output mapping from state bits
    assign walk_left  = state[2]; // WALK_LEFT or DIGGING (left)
    assign walk_right = state[1]; // WALK_RIGHT or DIGGING (right)
    assign aaah       = state[0]; // FALL state
    assign digging    = (state == DIGGING);
    
endmodule