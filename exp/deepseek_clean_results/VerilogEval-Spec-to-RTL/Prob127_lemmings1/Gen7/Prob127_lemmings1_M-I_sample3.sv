module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0 = left, 1 = right
    wire clk_enable = (state ? bump_right : bump_left) || areset;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else if (clk_enable) begin
            state <= ~state;  // Toggle state when bump occurs
        end
    end

    assign walk_left = ~state;
    assign walk_right = state;

endmodule