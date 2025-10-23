module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding with parameters for clarity
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;

    reg state;
    wire next_state;

    // Combinational next state logic - compact ternary form
    assign next_state = (state == LEFT) ? 
                       (bump_left ? RIGHT : LEFT) :
                       (bump_right ? LEFT : RIGHT);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Output assignments - direct and efficient
    assign walk_left = ~state;  // LEFT when state is 0
    assign walk_right = state;  // RIGHT when state is 1

endmodule