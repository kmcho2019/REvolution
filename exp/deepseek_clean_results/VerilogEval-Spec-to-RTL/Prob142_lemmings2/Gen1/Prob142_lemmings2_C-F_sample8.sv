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
    // State encoding optimized for output logic
    parameter WALK_LEFT  = 2'b00;  // walk_left=1, aaah=0
    parameter WALK_RIGHT = 2'b01;  // walk_right=1, aaah=0
    parameter FALL_LEFT  = 2'b10;  // walk_left=0, aaah=1
    parameter FALL_RIGHT = 2'b11;  // walk_right=0, aaah=1
    
    reg [1:0] state, next_state;
    
    // Optimized state transition logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                next_state = (!ground) ? FALL_LEFT :
                            (bump_left) ? WALK_RIGHT : WALK_LEFT;
            end
            WALK_RIGHT: begin
                next_state = (!ground) ? FALL_RIGHT :
                             (bump_right) ? WALK_LEFT : WALK_RIGHT;
            end
            FALL_LEFT: begin
                next_state = ground ? WALK_LEFT : FALL_LEFT;
            end
            FALL_RIGHT: begin
                next_state = ground ? WALK_RIGHT : FALL_RIGHT;
            end
        endcase
    end
    
    // State register with async reset and transition optimization
    always @(posedge clk, posedge areset) begin
        if (areset) state <= WALK_LEFT;
        else if (state != next_state) state <= next_state;  // Only update if changing
    end
    
    // Optimized output logic using state bit patterns
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = state[1];  // FALL states have MSB=1
    
endmodule