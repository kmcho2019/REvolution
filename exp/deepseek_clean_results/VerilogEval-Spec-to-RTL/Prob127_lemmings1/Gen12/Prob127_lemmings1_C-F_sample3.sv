module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;  // LEFT or RIGHT

    // Optimized state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= (state == LEFT) ? (bump_left ? RIGHT : LEFT)
                                     : (bump_right ? LEFT : RIGHT);
    end

    // Direct output assignments using state bit
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule