module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0: left, 1: right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else begin
            state <= (state & ~bump_right) | (~state & bump_left);
        end
    end

    assign walk_left = ~state;
    assign walk_right = state;

endmodule