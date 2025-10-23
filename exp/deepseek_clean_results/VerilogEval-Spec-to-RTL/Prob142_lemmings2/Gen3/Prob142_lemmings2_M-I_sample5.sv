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
    // State encoding optimized for output logic and minimal switching
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL_LEFT  = 2'b10;
    parameter FALL_RIGHT = 2'b11;
    
    reg [1:0] state, next_state;
    
    // Optimized parallel state transition logic
    always @(*) begin
        case (state)
            WALK_LEFT:  next_state = !ground ? FALL_LEFT  : 
                                    bump_left ? WALK_RIGHT : WALK_LEFT;
            WALK_RIGHT: next_state = !ground ? FALL_RIGHT : 
                                    bump_right ? WALK_LEFT : WALK_RIGHT;
            FALL_LEFT:  next_state = ground ? WALK_LEFT  : FALL_LEFT;
            FALL_RIGHT: next_state = ground ? WALK_RIGHT : FALL_RIGHT;
            default:    next_state = WALK_LEFT; // Safety net
        endcase
    end
    
    // Simplified state register without comparator
    always @(posedge clk, posedge areset) begin
        if (areset) state <= WALK_LEFT;
        else state <= next_state;
    end
    
    // Optimized output logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = state[1]; // MSB indicates falling state
    
endmodule