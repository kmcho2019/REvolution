module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding with localparams for readability
    localparam LEFT = 1'b0;
    localparam RIGHT = 1'b1;
    
    reg state;

    // Efficient XOR-based direction change logic
    wire change_dir = (state == LEFT) ? bump_left : bump_right;
    wire next_state = state ^ change_dir;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;  // Reset to walk left
        else
            state <= next_state;
    end

    // Direct output assignments (most efficient)
    assign walk_left = ~state;
    assign walk_right = state;

endmodule