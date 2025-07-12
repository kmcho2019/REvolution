module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;

    reg state;
    wire next_state, clk_en;

    // Clock gating when bump inputs change
    assign clk_en = bump_left || bump_right;

    // Optimized next state logic: 
    // If current state is LEFT, go RIGHT if bumped left, else stay
    // If current state is RIGHT, go LEFT if bumped right, else stay
    // Both bumps simultaneously will toggle direction
    assign next_state = (state ^ (bump_left & (state == LEFT)) ^ 
                        (bump_right & (state == RIGHT));

    // State register with async reset and clock gating
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else if (clk_en)
            state <= next_state;
    end

    // Output logic
    assign walk_left = ~state;
    assign walk_right = state;

endmodule