module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg toggle;
    reg bump_left_prev, bump_right_prev;
    wire bump_left_edge, bump_right_edge;

    // Edge detection for bump signals
    assign bump_left_edge = bump_left & ~bump_left_prev;
    assign bump_right_edge = bump_right & ~bump_right_prev;

    // Toggle flip logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            toggle <= 0;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end else begin
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
            if (bump_left_edge || bump_right_edge)
                toggle <= ~toggle;
        end
    end

    // Output logic - XOR with bump_right_edge gives correct direction
    assign walk_left = toggle ^ bump_right_edge;
    assign walk_right = ~walk_left;

endmodule