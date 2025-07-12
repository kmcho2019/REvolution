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
    // One-hot state encoding
    parameter WALK_LEFT  = 4'b0001;
    parameter WALK_RIGHT = 4'b0010;
    parameter FALL_LEFT  = 4'b0100;
    parameter FALL_RIGHT = 4'b1000;
    
    reg [3:0] state, next_state;
    
    // Next state logic using parallel assigns
    assign next_state[0] = (state == WALK_LEFT && ground && !bump_left) || 
                          (state == FALL_LEFT && ground) ||
                          (state == WALK_RIGHT && ground && bump_right);
    
    assign next_state[1] = (state == WALK_RIGHT && ground && !bump_right) || 
                          (state == FALL_RIGHT && ground) ||
                          (state == WALK_LEFT && ground && bump_left);
    
    assign next_state[2] = (state == WALK_LEFT && !ground) || 
                          (state == FALL_LEFT && !ground);
    
    assign next_state[3] = (state == WALK_RIGHT && !ground) || 
                          (state == FALL_RIGHT && !ground);
    
    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end
    
    // Output logic - direct from state bits
    assign walk_left  = state[0];
    assign walk_right = state[1];
    assign aaah       = state[2] | state[3];  // Either fall state
endmodule