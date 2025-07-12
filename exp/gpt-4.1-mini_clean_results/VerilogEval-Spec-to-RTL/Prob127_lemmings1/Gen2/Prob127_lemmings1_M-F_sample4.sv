module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;              // 0 = walk_left, 1 = walk_right
    reg prev_bump_left;
    reg prev_bump_right;

    // Registers to hold previous bump inputs for edge detection
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            prev_bump_left  <= 1'b0;
            prev_bump_right <= 1'b0;
        end else begin
            prev_bump_left  <= bump_left;
            prev_bump_right <= bump_right;
        end
    end

    // State register with asynchronous positive edge reset and edge-triggered toggling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0; // walk_left
        end else begin
            // Detect rising edges on bump_left or bump_right
            if ((bump_left & ~prev_bump_left) | (bump_right & ~prev_bump_right)) begin
                state <= ~state;
            end
        end
    end

    assign walk_left  = ~state;
    assign walk_right = state;

endmodule