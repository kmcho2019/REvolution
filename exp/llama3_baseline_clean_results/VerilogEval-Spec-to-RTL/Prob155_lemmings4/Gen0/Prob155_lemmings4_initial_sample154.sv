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

reg [2:0] state; // 0: WALKING_LEFT, 1: WALKING_RIGHT, 2: FALLING, 3: DIGGING, 4: SPLATTERED
reg [5:0] fall_count; // counter for number of clock cycles the Lemming has been falling
reg was_walking_left; // direction the Lemming was walking before it started falling or digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // WALKING_LEFT
        fall_count <= 0;
        was_walking_left <= 1;
    end else begin
        case (state)
            0: begin // WALKING_LEFT
                if (!ground) begin
                    state <= 2; // FALLING
                    was_walking_left <= 1;
                end else if (dig) begin
                    state <= 3; // DIGGING
                    was_walking_left <= 1;
                end else if (bump_left || (bump_right && !bump_left)) begin
                    state <= 1; // WALKING_RIGHT
                end
            end
            1: begin // WALKING_RIGHT
                if (!ground) begin
                    state <= 2; // FALLING
                    was_walking_left <= 0;
                end else if (dig) begin
                    state <= 3; // DIGGING
                    was_walking_left <= 0;
                end else if (bump_right || (bump_left && !bump_right)) begin
                    state <= 0; // WALKING_LEFT
                end
            end
            2: begin // FALLING
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4; // SPLATTERED
                    end else begin
                        if (was_walking_left) begin
                            state <= 0; // WALKING_LEFT
                        end else begin
                            state <= 1; // WALKING_RIGHT
                        end
                    end
                    fall_count <= 0;
                end
            end
            3: begin // DIGGING
                if (!ground) begin
                    state <= 2; // FALLING
                end else if (!dig) begin
                    if (was_walking_left) begin
                        state <= 0; // WALKING_LEFT
                    end else begin
                        state <= 1; // WALKING_RIGHT
                    end
                end
            end
            4: begin // SPLATTERED
                // do nothing, stay in this state forever
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // WALKING_LEFT
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin // WALKING_RIGHT
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
        4: begin // SPLATTERED
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule