module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state; // 0 = walk_left, 1 = walk_right
    reg bump_left_d, bump_right_d;

    // Register previous bump inputs to detect rising edges
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bump_left_d  <= 1'b0;
            bump_right_d <= 1'b0;
        end else begin
            bump_left_d  <= bump_left;
            bump_right_d <= bump_right;
        end
    end

    wire bump_left_rise  = bump_left  & ~bump_left_d;
    wire bump_right_rise = bump_right & ~bump_right_d;

    // State register with asynchronous positive edge reset and toggling on bump rising edges
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk_left
        else if (bump_left_rise | bump_right_rise)
            state <= ~state;
    end

    assign walk_left  = ~state;
    assign walk_right = state;

endmodule