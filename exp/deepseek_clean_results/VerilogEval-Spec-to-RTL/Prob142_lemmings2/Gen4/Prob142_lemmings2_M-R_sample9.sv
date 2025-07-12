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
    parameter WL = 4'b0001;  // Walk Left
    parameter WR = 4'b0010;  // Walk Right
    parameter FL = 4'b0100;  // Fall Left
    parameter FR = 4'b1000;  // Fall Right
    
    reg [3:0] state;
    
    // Next state logic using continuous assignments
    wire [3:0] next_state;
    assign next_state[0] = (state == WL && ground && !bump_left) || 
                          (state == FL && ground);
    assign next_state[1] = (state == WR && ground && !bump_right) || 
                          (state == FR && ground);
    assign next_state[2] = (state == WL && !ground) || 
                          (state == FL && !ground);
    assign next_state[3] = (state == WR && !ground) || 
                          (state == FR && !ground);
    
    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) state <= WL;
        else state <= next_state;
    end
    
    // Output logic - trivial with one-hot encoding
    assign walk_left  = state[0];
    assign walk_right = state[1];
    assign aaah       = state[2] | state[3];
    
endmodule