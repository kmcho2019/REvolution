module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0 = left, 1 = right
    wire clk_enable = bump_left | bump_right;

    // State register with async reset and clock gating
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else if (clk_enable) begin
            if (state == 0)
                state <= bump_left ? 1 : 0;
            else
                state <= bump_right ? 0 : 1;
        end
    end

    // Output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule