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

reg [2:0] state; // 0: walking_left, 1: walking_right, 2: falling, 3: digging, 4: splattered
reg [5:0] fall_count; // count the number of clock cycles the Lemming has been falling
reg [5:0] dig_count; // count the number of clock cycles the Lemming has been digging
reg original_direction; // keep track of the original direction of the Lemming before it starts digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // initialize state to walking_left
        fall_count <= 0;
        dig_count <= 0;
        original_direction <= 0;
    end else begin
        case (state)
            0: begin // walking_left
                if (!ground) begin
                    state <= 2; // start falling
                    fall_count <= 1;
                end else if (dig) begin
                    state <= 3; // start digging
                    original_direction <= 0;
                    dig_count <= 1;
                end else if (bump_left) begin
                    state <= 1; // switch to walking_right
                end
            end
            1: begin // walking_right
                if (!ground) begin
                    state <= 2; // start falling
                    fall_count <= 1;
                end else if (dig) begin
                    state <= 3; // start digging
                    original_direction <= 1;
                    dig_count <= 1;
                end else if (bump_right) begin
                    state <= 0; // switch to walking_left
                end
            end
            2: begin // falling
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4; // splattered
                    end else if (original_direction == 0) begin
                        state <= 0; // resume walking_left
                    end else begin
                        state <= 1; // resume walking_right
                    end
                    fall_count <= 0;
                end
            end
            3: begin // digging
                dig_count <= dig_count + 1;
                if (!ground) begin
                    state <= 2; // start falling
                    fall_count <= 1;
                end
            end
            4: begin // splattered
                // do nothing
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // walking_left
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin // walking_right
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        2: begin // falling
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        3: begin // digging
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        4: begin // splattered
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule