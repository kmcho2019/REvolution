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

reg walk_direction; // 0: left, 1: right
reg falling;

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        walk_direction <= 1'b0; // reset to walking left
        falling <= 1'b0; // reset to not falling
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        // direction controller
        if (bump_left == 1'b1 || bump_right == 1'b1) begin
            walk_direction <= ~walk_direction; // switch direction
        end

        // fall controller
        if (ground == 1'b0 && falling == 1'b0) begin
            falling <= 1'b1; // start falling
        end else if (ground == 1'b1 && falling == 1'b1) begin
            falling <= 1'b0; // stop falling
        end

        // output assignments
        if (falling == 1'b1) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
        end else begin
            if (walk_direction == 1'b0) begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end else begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
            aaah <= 1'b0;
        end
    end
end

endmodule