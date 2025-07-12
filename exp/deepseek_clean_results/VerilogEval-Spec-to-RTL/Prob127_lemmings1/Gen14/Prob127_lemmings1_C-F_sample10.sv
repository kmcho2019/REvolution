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
    
    reg state;  // LEFT or RIGHT

    // Efficient XOR-based direction change logic
    wire change_dir = (state == LEFT) ? bump_left : bump_right;
    wire next_state = state ^ change_dir;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Clear output assignments using parameters
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule