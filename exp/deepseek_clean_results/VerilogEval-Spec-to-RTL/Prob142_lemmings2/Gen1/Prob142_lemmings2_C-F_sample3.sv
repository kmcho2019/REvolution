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
    // State encoding - 2 bits binary
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL_LEFT  = 2'b10;
    parameter FALL_RIGHT = 2'b11;
    
    reg [1:0] state, next_state;
    
    // Optimized state transition logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) 
                    next_state = FALL_LEFT;
                else if (bump_left) 
                    next_state = WALK_RIGHT;
                else 
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground) 
                    next_state = FALL_RIGHT;
                else if (bump_right) 
                    next_state = WALK_LEFT;
                else 
                    next_state = WALK_RIGHT;
            end
            FALL_LEFT: 
                next_state = ground ? WALK_LEFT : FALL_LEFT;
            FALL_RIGHT: 
                next_state = ground ? WALK_RIGHT : FALL_RIGHT;
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
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = state[1];  // Both fall states have MSB=1
endmodule