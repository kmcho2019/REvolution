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

    // Registers for previous bump values to detect rising edges
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;       // walk_left
            bump_left_d <= 1'b0;
            bump_right_d <= 1'b0;
        end else begin
            bump_left_d <= bump_left;
            bump_right_d <= bump_right;

            // Rising edge detection of bump signals
            if ((bump_left & ~bump_left_d) || (bump_right & ~bump_right_d)) begin
                state <= ~state; // toggle direction only on bump rising edge
            end
        end
    end

    assign walk_left  = ~state;
    assign walk_right = state;

endmodule