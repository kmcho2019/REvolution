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

reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING, 3: DIGGING, 4: SPLATTERED
reg [4:0] fall_counter; // counter for the number of clock cycles the Lemming has been falling
reg previous_ground; // previous state of the ground
reg walk_direction; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // WALK_LEFT
        fall_counter <= 0;
        previous_ground <= 1;
        walk_direction <= 0; // left
    end else begin
        case (state)
            0: begin // WALK_LEFT
                if (!ground) begin
                    state <= 2; // FALLING
                    fall_counter <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                end else if (dig && !bump_left && !bump_right) begin
                    state <= 3; // DIGGING
                    walk_left <= 0;
                    walk_right <= 0;
                end else if (bump_right) begin
                    state <= 1; // WALK_RIGHT
                    walk_left <= 0;
                    walk_right <= 1;
                end else begin
                    walk_left <= 1;
                    walk_right <= 0;
                end
            end
            1: begin // WALK_RIGHT
                if (!ground) begin
                    state <= 2; // FALLING
                    fall_counter <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                end else if (dig && !bump_right && !bump_left) begin
                    state <= 3; // DIGGING
                    walk_left <= 0;
                    walk_right <= 0;
                end else if (bump_left) begin
                    state <= 0; // WALK_LEFT
                    walk_left <= 1;
                    walk_right <= 0;
                end else begin
                    walk_left <= 0;
                    walk_right <= 1;
                end
            end
            2: begin // FALLING
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4; // SPLATTERED
                    end else if (walk_direction) begin
                        state <= 1; // WALK_RIGHT
                        walk_left <= 0;
                        walk_right <= 1;
                    end else begin
                        state <= 0; // WALK_LEFT
                        walk_left <= 1;
                        walk_right <= 0;
                    end
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                    walk_left <= 0;
                    walk_right <= 0;
                end
            end
            3: begin // DIGGING
                if (!ground) begin
                    state <= 2; // FALLING
                    fall_counter <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                end else begin
                    walk_left <= 0;
                    walk_right <= 0;
                end
            end
            4: begin // SPLATTERED
                walk_left <= 0;
                walk_right <= 0;
            end
        endcase
        previous_ground <= ground;
        if (state == 2) begin // FALLING
            aaah <= 1;
        end else begin
            aaah <= 0;
        end
        if (state == 3) begin // DIGGING
            digging <= 1;
        end else begin
            digging <= 0;
        end
        if (state == 0 || state == 1) begin
            walk_direction <= state;
        end
    end
end

endmodule