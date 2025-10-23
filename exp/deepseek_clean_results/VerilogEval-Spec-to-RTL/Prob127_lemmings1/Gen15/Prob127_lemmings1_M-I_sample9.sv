module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0 = left, 1 = right
    wire state_change;
    wire gated_clk;

    // Detect when state needs to change
    assign state_change = (state & bump_right) | (~state & bump_left);

    // Clock gating when no state change needed
    assign gated_clk = clk & (areset | state_change);

    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else begin
            // Simplified state transition using direct selection
            state <= (state & ~bump_right) | (~state & bump_left);
        end
    end

    assign walk_left = ~state;
    assign walk_right = state;

endmodule