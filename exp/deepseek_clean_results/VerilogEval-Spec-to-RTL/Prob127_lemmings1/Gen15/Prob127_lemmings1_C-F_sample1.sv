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
    
    wire next_state;
    reg state;  // LEFT or RIGHT

    // Efficient XOR-based next state logic
    assign next_state = state ^ (state ? bump_right : bump_left);

    // DFF with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Clear output assignments
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule