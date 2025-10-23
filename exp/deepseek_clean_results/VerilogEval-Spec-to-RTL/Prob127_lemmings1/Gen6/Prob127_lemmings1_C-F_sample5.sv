module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Clear state definitions with compact encoding
    parameter WALK_LEFT = 1'b0;
    parameter WALK_RIGHT = 1'b1;
    
    reg state;
    
    // Efficient next-state logic with ternary operators
    wire next_state = (state == WALK_LEFT) ? 
                     (bump_left ? WALK_RIGHT : WALK_LEFT) :
                     (bump_right ? WALK_LEFT : WALK_RIGHT);

    // Clean state register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Direct output assignments for minimal logic
    assign walk_left = ~state;
    assign walk_right = state;

endmodule