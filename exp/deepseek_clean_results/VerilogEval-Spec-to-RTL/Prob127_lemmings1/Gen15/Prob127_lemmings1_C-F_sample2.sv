module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding with meaningful names
    localparam LEFT = 1'b0;
    localparam RIGHT = 1'b1;
    
    reg state;

    // Efficient transition logic combining XOR and explicit conditions
    wire change_dir = (state == LEFT) ? bump_left : bump_right;
    wire next_state = state ^ (bump_left | bump_right) ? change_dir : state;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;  // Reset to walk left
        else
            state <= next_state;
    end

    // Direct output assignments (most efficient)
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule