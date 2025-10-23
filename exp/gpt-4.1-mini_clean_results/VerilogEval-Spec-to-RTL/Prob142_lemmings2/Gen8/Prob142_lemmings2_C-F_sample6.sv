module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding:
    // bit1 (falling): 0 = walking, 1 = falling
    // bit0 (direction): 0 = left, 1 = right
    reg [1:0] state;
    reg [1:0] next_state;

    // Asynchronous reset logic: separate always block triggered by areset and clk
    // On areset: immediately reset state to walking left (2'b00)
    // On clk rising edge: update state with next_state
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // WALK_LEFT
        else
            state <= next_state;
    end

    // Next-state combinational logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        // Extract current state bits
        wire falling   = state[1];
        wire direction = state[0];

        if (falling) begin
            // Falling: ignore bumps, wait for ground
            if (ground)
                next_state = {1'b0, direction}; // back to walking with same direction
            else
                next_state = state; // keep falling
        end else begin
            // Walking
            if (!ground) begin
                // Ground disappeared: start falling, keep direction
                next_state = {1'b1, direction};
            end else begin
                // On ground and walking, handle bumps
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    next_state = {1'b0, ~direction};
                end else if (bump_left) begin
                    // bump_left: walk right
                    next_state = {1'b0, 1'b1};
                end else if (bump_right) begin
                    // bump_right: walk left
                    next_state = {1'b0, 1'b0};
                end else begin
                    // No bumps: remain walking same direction
                    next_state = state;
                end
            end
        end
    end

    // Moore outputs derived from state
    assign aaah       = state[1];
    assign walk_left  = (~state[1]) & (~state[0]);
    assign walk_right = (~state[1]) & state[0];

endmodule