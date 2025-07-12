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

reg mode_fall;    // 1 if falling
reg mode_dig;     // 1 if digging (only valid when !fall)
reg dir;          // 0=left, 1=right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode_fall <= 1'b0;
        mode_dig <= 1'b0;
        dir <= 1'b0;  // walk left
    end else begin
        if (mode_fall) begin
            // Currently falling
            if (ground) begin
                mode_fall <= 1'b0; // stop falling, resume walking
            end
            // else keep falling, direction unchanged
        end else if (mode_dig) begin
            // Currently digging
            if (!ground) begin
                mode_dig <= 1'b0;
                mode_fall <= 1'b1; // start falling
            end
            // else keep digging
        end else begin
            // Walking mode
            if (!ground) begin
                mode_fall <= 1'b1; // start falling
                mode_dig <= 1'b0;
            end else if (dig) begin
                mode_dig <= 1'b1; // start digging
            end else if (bump_left || bump_right) begin
                // change direction
                if (bump_left && bump_right) begin
                    dir <= ~dir;
                end else if (bump_left) begin
                    dir <= 1'b1; // walk right
                end else begin
                    dir <= 1'b0; // walk left
                end
            end
            // else keep walking same direction
        end
    end
end

assign walk_left  = !mode_fall && !mode_dig && (dir == 1'b0);
assign walk_right = !mode_fall && !mode_dig && (dir == 1'b1);
assign aaah       = mode_fall;
assign digging    = mode_dig;

endmodule