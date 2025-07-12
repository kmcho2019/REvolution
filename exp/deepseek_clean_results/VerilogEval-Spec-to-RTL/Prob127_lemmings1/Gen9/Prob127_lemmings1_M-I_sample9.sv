module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0: left, 1: right
    wire bump_any = bump_left | bump_right;
    wire clk_en = areset | bump_any;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else if (clk_en) begin
            state <= state ^ bump_any;
        end
    end

    assign walk_left = ~state;
    assign walk_right = state;

endmodule