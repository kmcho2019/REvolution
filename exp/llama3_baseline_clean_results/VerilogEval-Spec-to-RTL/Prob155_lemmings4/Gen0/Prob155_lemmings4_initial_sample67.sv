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

reg [4:0] state; // 0: idle, 1: walking left, 2: walking right, 3: falling, 4: digging, 5: splattered
reg [5:0] fall_counter; // counter for how long the Lemming has been falling
reg walk_direction; // 1 for left, 0 for right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        walk_direction <= 1; // default walk direction is left
        fall_counter <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (ground) begin
                    if (dig) begin
                        state <= 4; // start digging
                    end else begin
                        state <= 1; // start walking left
                    end
                end else begin
                    state <= 3; // start falling
                end
            end
            1: begin // walking left
                if (bump_left) begin
                    walk_direction <= 0; // switch direction to right
                    state <= 2;
                end else if (bump_right) begin
                    // do nothing, keep walking left
                end else if (!ground) begin
                    state <= 3; // start falling
                end else if (dig) begin
                    state <= 4; // start digging
                end
            end
            2: begin // walking right
                if (bump_left) begin
                    // do nothing, keep walking right
                end else if (bump_right) begin
                    walk_direction <= 1; // switch direction to left
                    state <= 1;
                end else if (!ground) begin
                    state <= 3; // start falling
                end else if (dig) begin
                    state <= 4; // start digging
                end
            end
            3: begin // falling
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 5; // splatter
                    end else begin
                        if (walk_direction) begin
                            state <= 1; // resume walking left
                        end else begin
                            state <= 2; // resume walking right
                        end
                    end
                    fall_counter <= 0;
                end
            end
            4: begin // digging
                if (!ground) begin
                    state <= 3; // start falling
                end
            end
            5: begin // splattered
                // do nothing, stay splattered
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        2: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        3: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        4: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        5: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule