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
    
    reg [3:0] state;
    
    // Next state logic using continuous assignments
    wire [3:0] next_state;
    assign next_state[0] = (state == WALK_LEFT && ground && !bump_left) || 
                          (state == FALL_LEFT && ground) ||
                          (areset);
    assign next_state[1] = (state == WALK_RIGHT && ground && !bump_right) || 
                          (state == FALL_LEFT && bump_left && ground) ||
                          (state == FALL_RIGHT && ground);
    assign next_state[2] = (state == WALK_LEFT && !ground) ||
                          (state == FALL_LEFT && !ground);
    assign next_state[3] = (state == WALK_RIGHT && !ground) ||
                          (state == FALL_RIGHT && !ground) ||
                          (state == WALK_LEFT && bump_left && ground);
    
    // State register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end
    
    // Output logic
    assign walk_left  = state[0];  // WALK_LEFT
    assign walk_right = state[1];  // WALK_RIGHT
    assign aaah = state[2] | state[3];  // FALL_LEFT or FALL_RIGHT

endmodule