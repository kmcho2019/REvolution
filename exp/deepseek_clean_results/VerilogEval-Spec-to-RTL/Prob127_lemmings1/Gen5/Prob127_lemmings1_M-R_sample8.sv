module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    reg state;  // 0 = WALK_LEFT, 1 = WALK_RIGHT

    // Next state logic (combinational)
    wire next_state = state ? 
                    (bump_right ? 1'b0 : 1'b1) :  // if WALK_RIGHT
                    (bump_left ? 1'b1 : 1'b0);    // if WALK_LEFT

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to WALK_LEFT
        else
            state <= next_state;
    end

    // Output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule