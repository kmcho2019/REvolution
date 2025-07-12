module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg direction; // 0 for left, 1 for right
reg falling; // 1 if lemming is falling

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        direction <= 1'b0; // reset to walking left
        falling <= 1'b0; // reset to not falling
        walk_left <= 1'b1; // reset to walking left
        walk_right <= 1'b0; // reset to walking left
        aaah <= 1'b0; // reset to not falling
    end else begin
        if (ground == 1'b0) begin
            falling <= 1'b1; // start falling
        end else if (ground == 1'b1 && falling == 1'b1) begin
            falling <= 1'b0; // stop falling
        end

        if (bump_left == 1'b1 || bump_right == 1'b1) begin
            direction <= ~direction; // change direction
        end

        if (falling == 1'b0) begin // not falling
            if (direction == 1'b0) begin // walking left
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end else begin // walking right
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
            aaah <= 1'b0;
        end else begin // falling
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
        end
    end
end

endmodule