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
    
    reg state = LEFT;  // Initialize to LEFT

    // Clocked state update with async reset
    assign #1 state = areset ? LEFT : 
                     (posedge clk) ? (state ^ (state ? bump_right : bump_left)) : state;

    // Output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule