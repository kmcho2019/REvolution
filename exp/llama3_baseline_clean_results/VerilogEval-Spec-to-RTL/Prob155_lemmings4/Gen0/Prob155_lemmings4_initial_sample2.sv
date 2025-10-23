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
reg [5:0] fall_counter; // counter for the number of clock cycles the Lemming has been falling
reg direction; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walking_left
        fall_counter <= 0;
        direction <= 0; // left
    end else begin
        case (state)
            0: begin // walking_left
                if (!ground) begin
                    state <= 2; // falling
                end else if (dig) begin
                    state <= 3; // digging
                end else if (bump_left) begin
                    state <= 1; // walking_right
                    direction <= 1; // right
                end else if (bump_right) begin
                    // do nothing
                end else begin
                    // do nothing
                end
            end
            1: begin // walking_right
                if (!ground) begin
                    state <= 2; // falling
                end else if (dig) begin
                    state <= 3; // digging
                end else if (bump_right) begin
                    state <= 0; // walking_left
                    direction <= 0; // left
                end else if (bump_left) begin
                    // do nothing
                end else begin
                    // do nothing
                end
            end
            2: begin // falling
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4; // splattered
                    end else begin
                        state <= direction ? 1 : 0; // walking_right or walking_left
                    end
                    fall_counter <= 0;
                end else begin
                    // do nothing
                end
            end
            3: begin // digging
                if (!ground) begin
                    state <= 2; // falling
                end else begin
                    // do nothing
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