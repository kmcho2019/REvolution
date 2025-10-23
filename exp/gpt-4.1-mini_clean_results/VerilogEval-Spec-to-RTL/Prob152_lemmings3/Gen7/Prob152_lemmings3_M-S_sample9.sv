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

localparam MODE_WALK = 2'd0;
localparam MODE_FALL = 2'd1;
localparam MODE_DIG  = 2'd2;

reg dir;           // 0=left, 1=right
reg [1:0] mode;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        dir <= 1'b0;        // walk left
        mode <= MODE_WALK;
    end else begin
        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    mode <= MODE_FALL;
                    // direction unchanged
                end else if (dig) begin
                    mode <= MODE_DIG;
                    // direction unchanged
                end else begin
                    mode <= MODE_WALK;
                    // Only update direction if bump occurs
                    if (bump_left || bump_right) begin
                        if (bump_left && bump_right)
                            dir <= ~dir;
                        else if (bump_left)
                            dir <= 1'b1;  // walk right
                        else if (bump_right)
                            dir <= 1'b0;  // walk left
                    end
                end
            end
            MODE_FALL: begin
                if (ground) begin
                    mode <= MODE_WALK;
                    // direction unchanged
                end else
                    mode <= MODE_FALL;
                // no dir change
            end
            MODE_DIG: begin
                if (!ground)
                    mode <= MODE_FALL;
                else
                    mode <= MODE_DIG;
                // no dir change
            end
            default: begin
                mode <= MODE_WALK;
                dir <= 1'b0;
            end
        endcase
    end
end

assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule