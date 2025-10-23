module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state encoding
    reg [1:0] state;  // [0] = WALK_LEFT, [1] = WALK_RIGHT

    // Next state logic using XOR for compact implementation
    wire walk_left_next = (state[0] & ~bump_left) | (state[1] & bump_right);
    wire walk_right_next = (state[1] & ~bump_right) | (state[0] & bump_left);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to WALK_LEFT
        end else begin
            state <= {walk_right_next, walk_left_next};
        end
    end

    // Direct output assignments from state bits
    assign walk_left = state[0];
    assign walk_right = state[1];

endmodule