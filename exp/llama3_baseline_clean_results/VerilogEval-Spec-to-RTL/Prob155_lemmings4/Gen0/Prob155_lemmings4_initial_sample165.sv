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

reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALL, 3: DIG, 4: SPLAT
reg [4:0] fall_counter;
reg walk_direction; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        walk_direction <= 0;
        fall_counter <= 0;
    end
    else begin
        case (state)
            0: begin // WALK_LEFT
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
                if (~ground) begin
                    state <= 2;
                    walk_direction <= 0;
                    fall_counter <= 1;
                end
                else if (dig) begin
                    state <= 3;
                    walk_direction <= 0;
                end
                else if (bump_right) begin
                    state <= 1;
                    walk_direction <= 1;
                end
            end
            1: begin // WALK_RIGHT
                walk_left <= 0;
                walk_right <= 1;
                aaah <= 0;
                digging <= 0;
                if (~ground) begin
                    state <= 2;
                    walk_direction <= 1;
                    fall_counter <= 1;
                end
                else if (dig) begin
                    state <= 3;
                    walk_direction <= 1;
                end
                else if (bump_left) begin
                    state <= 0;
                    walk_direction <= 0;
                end
            end
            2: begin // FALL
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
                digging <= 0;
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4;
                    end
                    else begin
                        state <= walk_direction;
                    end
                    fall_counter <= 0;
                end
            end
            3: begin // DIG
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 1;
                if (~ground) begin
                    state <= 2;
                    walk_direction <= walk_direction;
                    fall_counter <= 1;
                end
            end
            4: begin // SPLAT
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule