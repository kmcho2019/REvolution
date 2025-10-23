module TopModule(
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

reg [4:0] fall_count;
reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING, 3: DIGGING, 4: SPLATTER

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // WALK_LEFT
        fall_count <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            0: begin // WALK_LEFT
                if (!ground) begin
                    state <= 2; // FALLING
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                end else if (dig) begin
                    state <= 3; // DIGGING
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 1;
                end else if (bump_right) begin
                    state <= 1; // WALK_RIGHT
                    walk_left <= 0;
                    walk_right <= 1;
                end else if (bump_left) begin
                    state <= 1; // WALK_RIGHT
                    walk_left <= 0;
                    walk_right <= 1;
                end
            end
            1: begin // WALK_RIGHT
                if (!ground) begin
                    state <= 2; // FALLING
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                end else if (dig) begin
                    state <= 3; // DIGGING
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 1;
                end else if (bump_left) begin
                    state <= 0; // WALK_LEFT
                    walk_left <= 1;
                    walk_right <= 0;
                end else if (bump_right) begin
                    state <= 0; // WALK_LEFT
                    walk_left <= 1;
                    walk_right <= 0;
                end
            end
            2: begin // FALLING
                fall_count <= fall_count + 1;
                walk_left <= 0;
                walk_right <= 0;
                digging <= 0;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4; // SPLATTER
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        if (state == 0) begin
                            state <= 0; // WALK_LEFT
                            walk_left <= 1;
                            walk_right <= 0;
                        end else begin
                            state <= 1; // WALK_RIGHT
                            walk_left <= 0;
                            walk_right <= 1;
                        end
                        fall_count <= 0;
                        aaah <= 0;
                    end
                end
            end
            3: begin // DIGGING
                if (!ground) begin
                    state <= 2; // FALLING
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 0;
                    aaah <= 1;
                end
            end
            4: begin // SPLATTER
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule