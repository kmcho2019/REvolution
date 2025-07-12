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
    wire next_state;

    // Optimized XOR-based next state logic
    assign next_state = state ^ (state ? bump_right : bump_left);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Efficient output assignments using both parameter checks and implicit state
    assign walk_left = (state == LEFT);
    assign walk_right = state;

endmodule