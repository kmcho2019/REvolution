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
    
    wire next_state;
    reg state;  // Current state (LEFT or RIGHT)

    // Next state logic (combinational)
    assign next_state = (state == LEFT) ? 
                       (bump_left ? RIGHT : LEFT) :
                       (bump_right ? LEFT : RIGHT);

    // State storage (sequential with async reset)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule