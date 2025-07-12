module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Mode encoding
    localparam MODE_WALK = 1'b0;
    localparam MODE_FALL = 1'b1;

    // Registers for mode and direction
    reg mode;       // 0 = walking, 1 = falling or digging (will extend below)
    reg digging_reg; // 1 = digging, 0 = not digging (only meaningful when mode=walking)
    reg dir;        // 0 = left, 1 = right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            digging_reg <= 1'b0;
            dir <= 1'b0; // walk left on reset
        end else begin
            if (mode == MODE_FALL) begin
                // falling: stay falling until ground returns
                if (ground) begin
                    mode <= MODE_WALK;
                    digging_reg <= 1'b0; // not digging when walking again
                end
            end else begin
                // walking or digging
                if (!ground) begin
                    // ground gone: start falling (from walking or digging)
                    mode <= MODE_FALL;
                    digging_reg <= 1'b0;
                end else if (digging_reg) begin
                    // currently digging and ground remains
                    // continue digging until ground disappears, no dir change
                    // nothing changes in this state
                end else if (dig) begin
                    // start digging if walking and ground present
                    digging_reg <= 1'b1;
                end else begin
                    // walking and not digging, handle bumps to change direction
                    if (bump_left && bump_right)
                        dir <= ~dir;
                    else if (bump_left)
                        dir <= 1'b1; // walk right
                    else if (bump_right)
                        dir <= 1'b0; // walk left
                end
            end
        end
    end

    // Outputs are Moore style combinational
    assign walk_left  = (mode == MODE_WALK) && !digging_reg && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && !digging_reg && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_WALK) && digging_reg;

endmodule