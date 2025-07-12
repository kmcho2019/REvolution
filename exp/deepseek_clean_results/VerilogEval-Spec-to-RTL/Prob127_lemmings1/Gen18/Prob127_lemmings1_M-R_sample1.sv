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
    
    wire state;  // State is now a wire

    // State assignment with async reset and transition logic
    assign state = areset ? LEFT : 
                  (state == LEFT) ? (bump_left ? RIGHT : LEFT) :
                                   (bump_right ? LEFT : RIGHT);

    // Output assignments
    assign walk_left = ~state;  // Equivalent to state == LEFT
    assign walk_right = state;  // Equivalent to state == RIGHT

endmodule