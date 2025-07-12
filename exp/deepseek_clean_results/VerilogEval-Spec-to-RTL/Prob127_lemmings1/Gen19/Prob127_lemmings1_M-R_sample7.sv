module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    localparam LEFT = 1'b0;
    localparam RIGHT = 1'b1;
    
    reg state;  // Current state
    wire next_state;  // Next state (combinational)

    // Combinational next state logic
    assign next_state = (state == LEFT) ? 
                       (bump_left ? RIGHT : LEFT) : 
                       (bump_right ? LEFT : RIGHT);

    // Sequential state register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Output assignments
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule