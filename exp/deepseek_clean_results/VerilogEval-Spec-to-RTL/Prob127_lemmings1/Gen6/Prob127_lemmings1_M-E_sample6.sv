module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state encoding (bit 0: left, bit 1: right)
    reg [1:0] state;

    // Combine bump signals into direction toggle
    wire toggle_dir = bump_left | bump_right;

    // Next state logic using XOR
    wire [1:0] next_state = toggle_dir ? {state[0], state[1]} : state;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // Reset to WALK_LEFT (one-hot)
        else
            state <= next_state;
    end

    // Output assignments (direct from state bits)
    assign walk_left = state[0];
    assign walk_right = state[1];

endmodule