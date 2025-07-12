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

reg dir;      // 0=left, 1=right
reg falling;  // 1 if falling
reg digging_r; // 1 if digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        dir <= 1'b0;       // walk left
        falling <= 1'b0;
        digging_r <= 1'b0;
    end else begin
        if (falling) begin
            // If falling, stop falling when ground is back
            if (ground) begin
                falling <= 1'b0;
                // digging remains 0 after falling
                digging_r <= 1'b0;
                // direction unchanged
            end
            // else remain falling, no direction change or digging change
        end else if (digging_r) begin
            // Digging continues until ground disappears
            if (!ground) begin
                falling <= 1'b1;  // start falling after digging hole
                digging_r <= 1'b0;
                // direction unchanged
            end
            // else continue digging, no dir or falling change
        end else begin
            // Not falling or digging: walking on ground
            if (!ground) begin
                // start falling
                falling <= 1'b1;
                digging_r <= 1'b0;
                // direction unchanged
            end else if (dig) begin
                // start digging if dig=1 on ground and walking
                digging_r <= 1'b1;
                falling <= 1'b0;
                // direction unchanged
            end else if (bump_left || bump_right) begin
                // switch direction if bumped on any side
                dir <= ~dir;
                // no digging or falling change
                digging_r <= 1'b0;
                falling <= 1'b0;
            end
            // else remain walking same direction
        end
    end
end

assign walk_left = (~dir) && (~falling) && (~digging_r);
assign walk_right = dir && (~falling) && (~digging_r);
assign aaah = falling;
assign digging = digging_r;

endmodule