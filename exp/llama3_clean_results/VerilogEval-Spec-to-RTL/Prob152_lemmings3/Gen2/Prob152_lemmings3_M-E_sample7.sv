module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [0:0] direction; // 0: left, 1: right
reg [1:1] mode; // 0: walking, 1: falling, 2: digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 0;
        mode <= 0;
    end else begin
        // update direction
        if (mode == 0) begin // walking
            if (bump_left) begin
                direction <= 1;
            end else if (bump_right) begin
                direction <= 0;
            end
        end

        // update mode
        if (ground) begin
            if (mode == 1) begin // falling
                mode <= 0; // resume walking
            end else if (dig) begin
                mode <= 2; // start digging
            end
        end else begin
            if (mode == 0) begin // walking
                mode <= 1; // start falling
            end
        end
    end
end

always @(*) begin
    // update outputs
    if (mode == 1) begin // falling
        walk_left <= 0;
        walk_right <= 0;
        aaah <= 1;
        digging <= 0;
    end else if (mode == 2) begin // digging
        walk_left <= 0;
        walk_right <= 0;
        aaah <= 0;
        digging <= 1;
    end else begin // walking
        if (direction == 0) begin // left
            walk_left <= 1;
            walk_right <= 0;
        end else begin // right
            walk_left <= 0;
            walk_right <= 1;
        end
        aaah <= 0;
        digging <= 0;
    end
end

endmodule