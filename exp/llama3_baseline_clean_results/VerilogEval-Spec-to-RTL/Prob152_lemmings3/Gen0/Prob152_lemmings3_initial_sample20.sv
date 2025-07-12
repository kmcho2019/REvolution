module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging
reg direction; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walking left
        direction <= 0; // left
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (~ground) begin
                    state <= 2; // falling
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig) begin
                    state <= 3; // digging
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_left) begin
                    state <= 1; // walking right
                    direction <= 1; // right
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_right) begin
                    // no change
                end else begin
                    // no change
                end
            end
            1: begin // walking right
                if (~ground) begin
                    state <= 2; // falling
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig) begin
                    state <= 3; // digging
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_right) begin
                    state <= 0; // walking left
                    direction <= 0; // left
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_left) begin
                    // no change
                end else begin
                    // no change
                end
            end
            2: begin // falling
                if (ground) begin
                    if (direction) begin
                        state <= 1; // walking right
                        walk_left <= 0;
                        walk_right <= 1;
                    end else begin
                        state <= 0; // walking left
                        walk_left <= 1;
                        walk_right <= 0;
                    end
                    aaah <= 0;
                    digging <= 0;
                end else begin
                    // no change
                end
            end
            3: begin // digging
                if (~ground) begin
                    state <= 2; // falling
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else begin
                    // no change
                end
            end
            default: begin
                // no change
            end
        endcase
    end
end

endmodule