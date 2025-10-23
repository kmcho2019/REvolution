module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg flip_state;  // 0=no flip (left), 1=flipped (right)

    always @(posedge clk or posedge areset) begin
        if (areset)
            flip_state <= 0;
        else if (bump_left || bump_right)
            flip_state <= flip_state ^ (bump_left ^ bump_right);
    end

    assign walk_left = ~flip_state;
    assign walk_right = flip_state;

endmodule