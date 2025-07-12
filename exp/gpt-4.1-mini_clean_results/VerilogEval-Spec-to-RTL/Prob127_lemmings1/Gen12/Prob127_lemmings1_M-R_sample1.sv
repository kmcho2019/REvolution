module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk_left, 1 = walk_right
    reg state;

    // Sequential logic: state update and asynchronous reset combined
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to walk_left
        end else begin
            if (bump_left && bump_right) begin
                state <= ~state;  // Toggle direction on both bumps
            end else if (bump_left) begin
                state <= 1'b1;    // Bump left => walk right
            end else if (bump_right) begin
                state <= 1'b0;    // Bump right => walk left
            end
            // else retain current state
        end
    end

    // Moore outputs derived directly from state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule