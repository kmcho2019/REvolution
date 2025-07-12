module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [4:0] fall_counter; // counter to track number of clock cycles the Lemming has been falling
reg [1:0] state; // 0: walking, 1: falling, 2: digging, 3: splattered
reg prev_dir; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin // asynchronous reset
        state <= 0; // initial state: walking left
        prev_dir <= 0; // initial direction: left
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
        fall_counter <= 0;
    end else begin
        case (state)
            0: begin // walking
                if (!ground) begin // Lemming hits a hole
                    state <= 1; // transition to falling state
                    fall_counter <= 1;
                    aaah <= 1;
                end else if (dig) begin // Lemming starts digging
                    state <= 2; // transition to digging state
                    digging <= 1;
                end else if (bump_left && bump_right) begin // Lemming is bumped from both sides
                    prev_dir <= ~prev_dir; // switch direction
                    if (prev_dir) begin
                        walk_left <= 1;
                        walk_right <= 0;
                    end else begin
                        walk_left <= 0;
                        walk_right <= 1;
                    end
                end else if (bump_left) begin // Lemming is bumped from the left
                    prev_dir <= 1; // switch to right
                    walk_left <= 0;
                    walk_right <= 1;
                end else if (bump_right) begin // Lemming is bumped from the right
                    prev_dir <= 0; // switch to left
                    walk_left <= 1;
                    walk_right <= 0;
                end
            end
            1: begin // falling
                if (ground) begin // Lemming hits the ground
                    if (fall_counter > 20) begin // Lemming splatters
                        state <= 3; // transition to splattered state
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin // Lemming resumes walking
                        state <= 0; // transition to walking state
                        if (prev_dir) begin
                            walk_left <= 1;
                            walk_right <= 0;
                        end else begin
                            walk_left <= 0;
                            walk_right <= 1;
                        end
                        aaah <= 0;
                    end
                end else begin // Lemming continues falling
                    fall_counter <= fall_counter + 1;
                    aaah <= 1;
                end
            end
            2: begin // digging
                if (!ground) begin // Lemming reaches the other side
                    state <= 1; // transition to falling state
                    fall_counter <= 1;
                    digging <= 0;
                    aaah <= 1;
                end
            end
            3: begin // splattered
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule