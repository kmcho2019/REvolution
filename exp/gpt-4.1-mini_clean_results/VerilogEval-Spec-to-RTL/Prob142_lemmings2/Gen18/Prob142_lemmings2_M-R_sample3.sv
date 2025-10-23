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
    // bit1 = falling (1 = falling, 0 = walking)
    // bit0 = direction (0 = left, 1 = right)
    reg [1:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        if (state[1]) begin
            // Currently falling
            if (ground)
                next_state[1] = 1'b0; // landed, stop falling
            else
                next_state[1] = 1'b1; // keep falling
            // Direction unchanged while falling
            next_state[0] = state[0];
        end else begin
            // Currently walking
            if (~ground)
                next_state[1] = 1'b1; // start falling
            else
                next_state[1] = 1'b0; // keep walking

            // Update direction only when walking and bumped
            if (ground && (bump_left || bump_right)) begin
                if (bump_left && bump_right)
                    next_state[0] = ~state[0];    // flip direction
                else if (bump_left)
                    next_state[0] = 1'b1;          // walk right
                else if (bump_right)
                    next_state[0] = 1'b0;          // walk left
            end else begin
                next_state[0] = state[0];
            end
        end
    end

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // not falling, walking left
        else
            state <= next_state;
    end

    // Moore outputs from state
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule