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
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;
    
    reg [2:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right

    // Continuous assignments for next state logic
    assign next_state = 
        areset ? WALK : // Async reset
        (!ground && (state == WALK || state == DIG)) ? FALL : // Fall has highest priority
        (dig && ground && state == WALK) ? DIG : // Dig has middle priority
        (state == FALL && ground) ? WALK : // Return to walk after fall
        state; // Default: stay in current state

    // Continuous assignments for direction logic
    assign next_direction = 
        areset ? 1'b0 : // Reset to left
        (state == WALK && ground && !dig) ? // Only change direction when walking on ground
            (bump_left ? 1'b1 : 
             bump_right ? 1'b0 : 
             direction) :
        direction; // Maintain direction in other states

    // State and direction registers
    always @(posedge clk) begin
        state <= next_state;
        direction <= next_direction;
    end

    // Output logic
    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule