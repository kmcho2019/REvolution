module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    input           ground,
    input           dig,
    output          walk_left,
    output          walk_right,
    output          aaah,
    output          digging
);

reg [2:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging, 4: splattered
reg [4:0] fall_count; // count the number of clock cycles spent falling
reg        prev_walk_left; // remember the direction the Lemming was walking before falling or digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
        fall_count <= 0;
        prev_walk_left <= 1;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (!ground) begin
                    state <= 2; // start falling
                    prev_walk_left <= 1;
                end else if (dig) begin
                    state <= 3; // start digging
                    prev_walk_left <= 1;
                end else if (bump_left) begin
                    state <= 1; // switch to walking right
                end else if (bump_right) begin
                    // stay walking left
                end else begin
                    // stay walking left
                end
            end
            1: begin // walking right
                if (!ground) begin
                    state <= 2; // start falling
                    prev_walk_left <= 0;
                end else if (dig) begin
                    state <= 3; // start digging
                    prev_walk_left <= 0;
                end else if (bump_left) begin
                    // stay walking right
                end else if (bump_right) begin
                    state <= 0; // switch to walking left
                end else begin
                    // stay walking right
                end
            end
            2: begin // falling
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4; // splatter
                    end else begin
                        if (prev_walk_left) begin
                            state <= 0; // resume walking left
                        end else begin
                            state <= 1; // resume walking right
                        end
                    end
                    fall_count <= 0;
                end else begin
                    // keep falling
                end
            end
            3: begin // digging
                if (!ground) begin
                    state <= 2; // start falling
                    prev_walk_left <= prev_walk_left;
                end else begin
                    // keep digging
                end
            end
            4: begin // splattered
                // stay splattered
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // walking left
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin // walking right
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