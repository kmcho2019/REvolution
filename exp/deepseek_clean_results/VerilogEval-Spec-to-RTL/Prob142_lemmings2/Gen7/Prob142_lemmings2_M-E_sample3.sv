module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    // State encoding:
    // bit[1]: 1=falling, 0=walking
    // bit[0]: 1=right, 0=left
    reg [1:0] state;

    // Next state logic
    wire [1:0] next_state;
    assign next_state = 
        (!ground) ? {1'b1, state[0]} :  // Preserve direction when falling
        (bump_left && !bump_right) ? 2'b01 :  // Switch to right if left bump
        (bump_right && !bump_left) ? 2'b00 :  // Switch to left if right bump
        (bump_left && bump_right) ? {1'b0, ~state[0]} :  // Toggle if both bumps
        {1'b0, state[0]};  // Default: keep walking same direction

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= 2'b00;  // Start walking left
        else
            state <= next_state;
    end

    // Output logic - derived directly from state bits
    assign walk_left = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah = state[1];
endmodule