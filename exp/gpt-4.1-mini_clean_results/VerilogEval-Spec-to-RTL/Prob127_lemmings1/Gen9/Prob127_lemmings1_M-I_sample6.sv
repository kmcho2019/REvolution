module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // Synchronize bump inputs to clk domain to reduce glitches and metastability
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

    wire bump_left_sync  = bump_left_sync_1;
    wire bump_right_sync = bump_right_sync_1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0; // walk_left
        end else begin
            // next-state logic simplified by checking bumps synchronously
            if (bump_left_sync & bump_right_sync) begin
                state <= ~state; // bump both sides, toggle direction
            end else if (bump_left_sync) begin
                state <= 1'b1;   // bumped left, walk right
            end else if (bump_right_sync) begin
                state <= 1'b0;   // bumped right, walk left
            end
            // else hold state
        end
    end

    assign walk_left  = ~state;
    assign walk_right = state;

endmodule