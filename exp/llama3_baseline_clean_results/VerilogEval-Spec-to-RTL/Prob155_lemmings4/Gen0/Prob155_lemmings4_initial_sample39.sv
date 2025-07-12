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

reg [1:0] state; // 0: Walking Left, 1: Walking Right, 2: Falling, 3: Digging, 4: Dead
reg [4:0] fall_counter; // counter to keep track of how long the Lemming has been falling
reg direction; // direction the Lemming was walking before falling or digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to Walking Left
        direction <= 0; // reset direction to Left
        fall_counter <= 0; // reset fall counter
    end else begin
        case (state)
            0: begin // Walking Left
                if (!ground) begin
                    state <= 2; // start falling
                    direction <= 0; // save current direction
                end else if (dig) begin
                    state <= 3; // start digging
                    direction <= 0; // save current direction
                end else if (bump_right) begin
                    state <= 1; // switch to Walking Right
                end
            end
            1: begin // Walking Right
                if (!ground) begin
                    state <= 2; // start falling
                    direction <= 1; // save current direction
                end else if (dig) begin
                    state <= 3; // start digging
                    direction <= 1; // save current direction
                end else if (bump_left) begin
                    state <= 0; // switch to Walking Left
                end
            end
            2: begin // Falling
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4; // splatter
                    end else begin
                        state <= direction ? 1 : 0; // resume walking in previous direction
                    end
                    fall_counter <= 0; // reset fall counter
                end
            end
            3: begin // Digging
                if (!ground) begin
                    state <= 2; // start falling
                    direction <= direction; // save current direction
                end
            end
            4: begin // Dead
                // do nothing
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // Walking Left
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin // Walking Right
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        2: begin // Falling
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        3: begin // Digging
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        4: begin // Dead
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule