module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state; // 0: walking_left, 1: walking_right, 2: falling, 3: digging, 4: splattered
reg [1:0] prev_state; // previous state
reg [4:0] fall_counter; // counter for falling clock cycles
reg walking_dir; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walking_left
        prev_state <= 0;
        fall_counter <= 0;
        walking_dir <= 0; // left
    end else begin
        case (state)
            0: begin // walking_left
                if (~ground) begin
                    state <= 2; // falling
                    prev_state <= 0; // walking_left
                    fall_counter <= 1;
                end else if (dig && ground) begin
                    state <= 3; // digging
                    prev_state <= 0; // walking_left
                end else if (bump_right) begin
                    state <= 1; // walking_right
                end
            end
            1: begin // walking_right
                if (~ground) begin
                    state <= 2; // falling
                    prev_state <= 1; // walking_right
                    fall_counter <= 1;
                end else if (dig && ground) begin
                    state <= 3; // digging
                    prev_state <= 1; // walking_right
                end else if (bump_left) begin
                    state <= 0; // walking_left
                end
            end
            2: begin // falling
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4; // splattered
                    end else begin
                        state <= prev_state; // resume walking
                    end
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            3: begin // digging
                if (~ground) begin
                    state <= 2; // falling
                    prev_state <= 3; // digging
                    fall_counter <= 1;
                end else if (~dig) begin
                    state <= prev_state; // resume walking
                end
            end
            4: begin // splattered
                // stay in this state forever
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