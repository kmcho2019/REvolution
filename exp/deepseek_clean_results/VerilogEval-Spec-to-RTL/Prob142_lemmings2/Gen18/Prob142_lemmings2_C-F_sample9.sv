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
    // bit[1]: 0=WALK, 1=FALL
    // bit[0]: direction (0=left, 1=right)
    reg [1:0] state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // Walk left
        end
        else if (state[1]) begin
            // Falling
            if (ground) state <= {1'b0, state[0]}; // Resume walking
        end
        else begin
            // Walking
            if (!ground) begin
                state <= {1'b1, state[0]}; // Start falling
            end
            else if ((bump_left && !state[0]) || (bump_right && state[0])) begin
                state[0] <= ~state[0]; // Toggle direction
            end
        end
    end

    assign walk_left = (~state[1]) & (~state[0]);
    assign walk_right = (~state[1]) & state[0];
    assign aaah = state[1];

endmodule