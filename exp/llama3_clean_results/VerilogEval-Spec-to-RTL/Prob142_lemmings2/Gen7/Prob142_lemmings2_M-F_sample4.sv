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
reg state; // 0 for walking, 1 for falling
reg prev_ground; // previous value of ground

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        direction <= 0; // reset to walking left
        state <= 0; // reset to walking
        prev_ground <= 1'b1; // reset previous ground to high
    end else begin
        // Update previous ground value
        prev_ground <= ground;

        // Update state
        if (ground == 1'b0) begin
            state <= 1'b1; // falling
        end else if (state == 1'b1 && ground == 1'b1) begin
            state <= 1'b0; // resume walking
        end

        // Update direction only when walking
        if (state == 1'b0) begin
            if (bump_left == 1'b1 && bump_right == 1'b1) begin
                direction <= ~direction; // toggle direction
            end else if (bump_left == 1'b1) begin
                direction <= 1'b0; // walking left
            end else if (bump_right == 1'b1) begin
                direction <= 1'b1; // walking right
            end
        end
    end
end

always @(*) begin
    if (state == 1'b1) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b1;
    end else begin
        walk_left = ~direction;
        walk_right = direction;
        aaah = 1'b0;
    end
end

endmodule