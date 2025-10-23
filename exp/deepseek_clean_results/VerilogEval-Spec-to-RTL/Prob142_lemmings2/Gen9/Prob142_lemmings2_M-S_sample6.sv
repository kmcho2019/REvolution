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
    
    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // Start walking left
        end
        else begin
            // State transition
            state <= ground ? (state == FALL ? WALK : state) : FALL;
            
            // Direction update (only when walking on ground)
            if (state == WALK && ground)
                direction <= direction ^ (bump_left | bump_right);
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule