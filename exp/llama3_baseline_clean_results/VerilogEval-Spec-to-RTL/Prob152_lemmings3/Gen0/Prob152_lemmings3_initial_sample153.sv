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

    reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING, 3: DIGGING
    reg prev_direction; // 0: left, 1: right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0; // WALK_LEFT
            prev_direction <= 0; // left
        end else begin
            case (state)
                0: begin // WALK_LEFT
                    if (!ground) begin
                        state <= 2; // FALLING
                    end else if (bump_right) begin
                        state <= 1; // WALK_RIGHT
                        prev_direction <= 1; // right
                    end else if (dig) begin
                        state <= 3; // DIGGING
                    end
                end
                1: begin // WALK_RIGHT
                    if (!ground) begin
                        state <= 2; // FALLING
                    end else if (bump_left) begin
                        state <= 0; // WALK_LEFT
                        prev_direction <= 0; // left
                    end else if (dig) begin
                        state <= 3; // DIGGING
                    end
                end
                2: begin // FALLING
                    if (ground) begin
                        if (prev_direction == 0) begin
                            state <= 0; // WALK_LEFT
                        end else begin
                            state <= 1; // WALK_RIGHT
                        end
                    end
                end
                3: begin // DIGGING
                    if (!ground) begin
                        state <= 2; // FALLING
                    end
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            0: begin // WALK_LEFT
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
            1: begin // WALK_RIGHT
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
            end
            2: begin // FALLING
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end
            3: begin // DIGGING
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end
        endcase
    end

endmodule