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

    // States
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    
    reg state;
    reg direction;  // 0=left, 1=right
    
    // Next state and direction logic
    wire next_state;
    wire next_direction;
    
    assign next_state = (state == WALK) ? 
                       (!ground ? FALL : WALK) : 
                       (ground ? WALK : FALL);
    
    assign next_direction = (state == WALK && ground) ? 
                           ((direction && bump_right) || (!direction && bump_left) ? 
                           ~direction : direction) : 
                           direction;
    
    // State and direction registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // Start walking left
        end
        else begin
            state <= next_state;
            // Only update direction when in WALK state and ground is present
            if (state == WALK && ground)
                direction <= next_direction;
        end
    end
    
    // Output logic - Moore style
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule