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

    // States - one-hot encoded (though minimal benefit with 2 states)
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    
    reg state, next_state;
    reg direction, next_direction;  // 0=left, 1=right
    wire direction_enable = (state == WALK) && ground;  // Clock gating condition
    
    // State transition logic (simplified)
    always @(*) begin
        next_state = state;
        if (state == WALK) begin
            if (!ground) next_state = FALL;
        end
        else begin  // FALL state
            if (ground) next_state = WALK;
        end
    end
    
    // Direction logic (separated from state transitions)
    always @(*) begin
        if (state == WALK && ground) begin
            if ((!direction && bump_left) || (direction && bump_right))
                next_direction = ~direction;
            else
                next_direction = direction;
        end
        else begin
            next_direction = direction;  // Maintain direction during fall
        end
    end
    
    // State and direction registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // Start walking left
        end
        else begin
            state <= next_state;
            if (direction_enable) direction <= next_direction;
        end
    end
    
    // Output logic (optimized)
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule