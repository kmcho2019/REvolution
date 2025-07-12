module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot registers for each state
    reg walk_left_reg, walk_right_reg;
    reg walk_left_next, walk_right_next;

    // Next state logic combinational block
    always @(*) begin
        // Default hold state
        walk_left_next  = walk_left_reg;
        walk_right_next = walk_right_reg;

        if (bump_left && bump_right) begin
            // Toggle states when both bumps occur
            walk_left_next  = walk_right_reg;
            walk_right_next = walk_left_reg;
        end else if (bump_left) begin
            // Bump left: walk right
            walk_left_next  = 1'b0;
            walk_right_next = 1'b1;
        end else if (bump_right) begin
            // Bump right: walk left
            walk_left_next  = 1'b1;
            walk_right_next = 1'b0;
        end
        // else: no bumps, hold current state
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_reg  <= 1'b1; // reset to walk left
            walk_right_reg <= 1'b0;
        end else begin
            walk_left_reg  <= walk_left_next;
            walk_right_reg <= walk_right_next;
        end
    end

    // Moore outputs directly from one-hot registers
    assign walk_left  = walk_left_reg;
    assign walk_right = walk_right_reg;

endmodule