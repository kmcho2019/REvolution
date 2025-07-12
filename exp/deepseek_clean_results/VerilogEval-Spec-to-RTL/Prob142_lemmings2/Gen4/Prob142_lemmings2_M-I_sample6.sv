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
    // One-hot state encoding for potentially better timing
    parameter WALK_LEFT  = 3'b001;
    parameter WALK_RIGHT = 3'b010;
    parameter FALL_LEFT  = 3'b100;
    parameter FALL_RIGHT = 3'b101;
    
    reg [2:0] state, next_state;
    
    // Parallel state transition logic
    always @(*) begin
        next_state = 3'b0; // Default
        case (1'b1)
            state[0]: // WALK_LEFT
                if (!ground) next_state = FALL_LEFT;
                else if (bump_left) next_state = WALK_RIGHT;
                else next_state = WALK_LEFT;
            
            state[1]: // WALK_RIGHT
                if (!ground) next_state = FALL_RIGHT;
                else if (bump_right) next_state = WALK_LEFT;
                else next_state = WALK_RIGHT;
            
            state[2]: // FALL_LEFT or FALL_RIGHT
                if (ground) next_state = state[0] ? WALK_LEFT : WALK_RIGHT;
                else next_state = state;
            
            default: next_state = WALK_LEFT;
        endcase
    end
    
    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) state <= WALK_LEFT;
        else state <= next_state;
    end
    
    // Optimized output logic
    assign walk_left  = state[0];
    assign walk_right = state[1];
    assign aaah       = state[2];
    
endmodule