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

reg [1:0] state;
reg direction; // 0 for left, 1 for right

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
                if (!ground) begin
                    state <= 2; // falling
                    aaah <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                end else if (dig && ground) begin
                    state <= 3; // digging
                    digging <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                end else if (bump_left) begin
                    direction <= 1; // right
                    state <= 1; // walking right
                    walk_left <= 0;
                    walk_right <= 1;
                end else if (bump_right) begin
                    // already walking left, no change
                end else begin
                    // no change
                end
            end
            1: begin // walking right
                if (!ground) begin
                    state <= 2; // falling
                    aaah <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                end else if (dig && ground) begin
                    state <= 3; // digging
                    digging <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                end else if (bump_right) begin
                    direction <= 0; // left
                    state <= 0; // walking left
                    walk_left <= 1;
                    walk_right <= 0;
                end else if (bump_left) begin
                    // already walking right, no change
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
                end else begin
                    // still falling
                end
            end
            3: begin // digging
                if (!ground) begin
                    state <= 2; // falling
                    aaah <= 1;
                    digging <= 0;
                    walk_left <= 0;
                    walk_right <= 0;
                end else begin
                    // still digging
                end
            end
            default: begin
                // invalid state
            end
        endcase
    end
end

endmodule