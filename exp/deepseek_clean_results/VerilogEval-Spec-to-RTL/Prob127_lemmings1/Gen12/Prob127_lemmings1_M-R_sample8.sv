module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State representation and transition logic
    wire state, next_state;
    
    // Next state logic
    assign next_state = state ? ~bump_right : bump_left;
    
    // State storage with async reset
    assign state = areset ? 1'b0 : (clk ? (posedge clk ? next_state : state) : state);
    
    // Output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule