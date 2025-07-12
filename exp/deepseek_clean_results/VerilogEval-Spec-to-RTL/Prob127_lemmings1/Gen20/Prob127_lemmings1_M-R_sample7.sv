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
    
    wire state, next_state;

    // Next state logic
    assign next_state = (state == LEFT) ? 
                       (bump_left ? RIGHT : LEFT) :
                       (bump_right ? LEFT : RIGHT);

    // State register with async reset
    assign state = areset ? LEFT : 
                  (posedge clk) ? next_state : state;

    // Output logic
    assign walk_left = (next_state == LEFT);
    assign walk_right = (next_state == RIGHT);

endmodule