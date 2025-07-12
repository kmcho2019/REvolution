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

reg [2:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging, 4: splattered
reg [4:0] fall_counter; // counter to track number of clock cycles falling

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
        fall_counter <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (!ground) begin
                    state <= 2; // fall
                    fall_counter <= 1;
                end else if (dig && ground) begin
                    state <= 3; // dig
                end else if (bump_left) begin
                    state <= 1; // walk right
                end
            end
            1: begin // walking right
                if (!ground) begin
                    state <= 2; // fall
                    fall_counter <= 1;
                end else if (dig && ground) begin
                    state <= 3; // dig
                end else if (bump_right) begin
                    state <= 0; // walk left
                end
            end
            2: begin // falling
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4; // splattered
                    end else begin
                        state <= (state == 2) ? 0 : 1; // resume walking
                    end
                    fall_counter <= 0;
                end
            end
            3: begin // digging
                if (!ground) begin
                    state <= 2; // fall
                    fall_counter <= 1;
                end else if (!dig) begin
                    state <= (state == 3) ? 0 : 1; // resume walking
                end
            end
            4: begin // splattered
                // stay in splattered state
            end
        endcase
    end
end

always @ (*) begin
    case (state)
        0: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        2: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        3: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        4: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule