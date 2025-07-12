module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output [1:0] walk_dir,  // [1] = left, [0] = right
    output aaah
);
    // Gray-coded state encoding for minimal bit toggles
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL_RIGHT = 2'b11;
    parameter FALL_LEFT  = 2'b10;
    
    reg [1:0] state, next_state;
    
    // Flattened state transition logic
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
            FALL_LEFT:  next_state = ground ? WALK_LEFT : FALL_LEFT;
            FALL_RIGHT: next_state = ground ? WALK_RIGHT : FALL_RIGHT;
        endcase
    end
    
    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) 
            state <= WALK_LEFT;
        else 
            state <= next_state;
    end
    
    // Optimized output logic
    assign walk_dir[1] = (state == WALK_LEFT);  // walk_left
    assign walk_dir[0] = (state == WALK_RIGHT); // walk_right
    assign aaah = state[1];  // Both fall states have MSB=1
endmodule