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

    reg [2:0] state;
    reg [5:0] fall_count;
    reg direction; // 0: left, 1: right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0; // IDLE
            direction <= 0; // left
            fall_count <= 0;
        end else begin
            case (state)
                0: // IDLE
                    begin
                        if (ground) begin
                            if (dig) begin
                                state <= 3; // DIGGING
                            end else if (bump_left) begin
                                state <= 1; // WALKING_RIGHT
                                direction <= 1; // right
                            end else if (bump_right) begin
                                state <= 2; // WALKING_LEFT
                                direction <= 0; // left
                            end else begin
                                state <= 2; // WALKING_LEFT
                            end
                        end else begin
                            state <= 4; // FALLING
                        end
                    end
                1: // WALKING_RIGHT
                    begin
                        if (ground) begin
                            if (dig) begin
                                state <= 3; // DIGGING
                            end else if (bump_left) begin
                                state <= 2; // WALKING_LEFT
                                direction <= 0; // left
                            end else if (bump_right) begin
                                state <= 1; // WALKING_RIGHT
                            end
                        end else begin
                            state <= 4; // FALLING
                        end
                    end
                2: // WALKING_LEFT
                    begin
                        if (ground) begin
                            if (dig) begin
                                state <= 3; // DIGGING
                            end else if (bump_right) begin
                                state <= 1; // WALKING_RIGHT
                                direction <= 1; // right
                            end else if (bump_left) begin
                                state <= 2; // WALKING_LEFT
                            end
                        end else begin
                            state <= 4; // FALLING
                        end
                    end
                3: // DIGGING
                    begin
                        if (!ground) begin
                            state <= 4; // FALLING
                        end
                    end
                4: // FALLING
                    begin
                        fall_count <= fall_count + 1;
                        if (ground) begin
                            if (fall_count > 20) begin
                                state <= 5; // SPLATTERED
                            end else begin
                                if (direction) begin
                                    state <= 1; // WALKING_RIGHT
                                end else begin
                                    state <= 2; // WALKING_LEFT
                                end
                            end
                            fall_count <= 0;
                        end
                    end
                5: // SPLATTERED
                    begin
                        // do nothing
                    end
            endcase
        end
    end

    always @(*) begin
        case (state)
            0, 2: walk_left = 1; walk_right = 0; aaah = 0; digging = 0;
            1: walk_left = 0; walk_right = 1; aaah = 0; digging = 0;
            3: walk_left = 0; walk_right = 0; aaah = 0; digging = 1;
            4: walk_left = 0; walk_right = 0; aaah = 1; digging = 0;
            5: walk_left = 0; walk_right = 0; aaah = 0; digging = 0;
        endcase
    end

endmodule