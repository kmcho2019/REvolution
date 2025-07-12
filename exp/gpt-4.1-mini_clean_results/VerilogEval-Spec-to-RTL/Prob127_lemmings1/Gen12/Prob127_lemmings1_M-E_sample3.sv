module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg walk_left_state;
    reg walk_right_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_state  <= 1'b1;
            walk_right_state <= 1'b0;
        end else begin
            if (bump_left && bump_right) begin
                // Toggle direction
                walk_left_state  <= walk_right_state;
                walk_right_state <= walk_left_state;
            end else if (bump_left) begin
                // bump left => walk right
                walk_left_state  <= 1'b0;
                walk_right_state <= 1'b1;
            end else if (bump_right) begin
                // bump right => walk left
                walk_left_state  <= 1'b1;
                walk_right_state <= 1'b0;
            end
            // else no change, hold states
        end
    end

    assign walk_left  = walk_left_state;
    assign walk_right = walk_right_state;

endmodule