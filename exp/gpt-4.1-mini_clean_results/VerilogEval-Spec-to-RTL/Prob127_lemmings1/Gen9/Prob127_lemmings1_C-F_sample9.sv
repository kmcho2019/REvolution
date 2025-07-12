module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // Synchronize asynchronous bump inputs to clk domain to avoid metastability and glitches
    reg bump_left_sync_0, bump_left_sync_1;
    reg bump_right_sync_0, bump_right_sync_1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bump_left_sync_0  <= 1'b0;
            bump_left_sync_1  <= 1'b0;
            bump_right_sync_0 <= 1'b0;
            bump_right_sync_1 <= 1'b0;
        end else begin
            bump_left_sync_0  <= bump_left;
            bump_left_sync_1  <= bump_left_sync_0;
            bump_right_sync_0 <= bump_right;
            bump_right_sync_1 <= bump_right_sync_0;
        end
    end

    reg state; // 0 = walk_left, 1 = walk_right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0; // walk_left
        end else begin
            // Use synchronized bump inputs for stable state transitions
            if (bump_left_sync_1 & bump_right_sync_1) begin
                state <= ~state;        // bump both, toggle direction
            end else if (bump_left_sync_1) begin
                state <= 1'b1;          // bump_left, walk_right
            end else if (bump_right_sync_1) begin
                state <= 1'b0;          // bump_right, walk_left
            end
            // else state remains unchanged
        end
    end

    // Moore outputs derived directly from state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule