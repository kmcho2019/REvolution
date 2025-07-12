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

reg [2:0] state; // walking_left (0), walking_right (1), falling (2), digging (3), splattered (4)
reg [4:0] fall_count; // count of clock cycles since Lemming started falling
reg direction; // 0 for left, 1 for right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // initialize state to walking_left
        direction <= 0; // initialize direction to left
        fall_count <= 0; // initialize fall count to 0
    end else begin
        case (state)
            0: begin // walking_left
                if (~ground) begin
                    state <= 2; // transition to falling
                    fall_count <= 1; // start counting clock cycles
                end else if (dig && ground) begin
                    state <= 3; // transition to digging
                end else if (bump_left || bump_right) begin
                    direction <= ~direction; // switch direction
                    if (direction) begin
                        state <= 1; // transition to walking_right
                    end
                end
            end
            1: begin // walking_right
                if (~ground) begin
                    state <= 2; // transition to falling
                    fall_count <= 1; // start counting clock cycles
                end else if (dig && ground) begin
                    state <= 3; // transition to digging
                end else if (bump_left || bump_right) begin
                    direction <= ~direction; // switch direction
                    if (~direction) begin
                        state <= 0; // transition to walking_left
                    end
                end
            end
            2: begin // falling
                fall_count <= fall_count + 1; // increment fall count
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4; // transition to splattered
                    end else begin
                        state <= direction ? 1 : 0; // transition to walking in previous direction
                    end
                    fall_count <= 0; // reset fall count
                end
            end
            3: begin // digging
                if (~ground) begin
                    state <= 2; // transition to falling
                    fall_count <= 1; // start counting clock cycles
                end else if (~dig) begin
                    state <= direction ? 1 : 0; // transition to walking in previous direction
                end
            end
            4: begin // splattered
                // do nothing, stay in this state
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