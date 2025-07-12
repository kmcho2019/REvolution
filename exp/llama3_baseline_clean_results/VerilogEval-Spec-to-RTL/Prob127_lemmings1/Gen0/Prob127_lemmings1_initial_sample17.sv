module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg state;
reg next_state;

always @(*) begin
    // Next state logic
    if (bump_left == 1'b1 || bump_right == 1'b1) begin
        next_state = ~state;
    end else begin
        next_state = state;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        // Asynchronous reset
        state <= 1'b0;
    end else begin
        // Synchronous state update
        state <= next_state;
    end
end

always @(*) begin
    // Output logic
    if (state == 1'b0) begin
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        walk_left <= 1'b0;
        walk_right <= 1'b1;
    end
end

endmodule