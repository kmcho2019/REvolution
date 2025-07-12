module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state encoding
    // state[0] = walk_left, state[1] = walk_right
    reg [1:0] state;

    // Next state logic with priority encoder
    wire [1:0] next_state;
    assign next_state = (bump_left && state[0]) ? 2'b10 :  // Left bump has priority
                       (bump_right && state[1]) ? 2'b01 :
                       state;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // Reset to walk_left
        else
            state <= next_state;
    end

    // Direct output assignment from state bits
    assign walk_left = state[0];
    assign walk_right = state[1];

endmodule