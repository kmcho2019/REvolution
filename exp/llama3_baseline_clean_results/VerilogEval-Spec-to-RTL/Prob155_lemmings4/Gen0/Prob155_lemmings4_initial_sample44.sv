module TopModule (
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

reg [2:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALL, 3: DIG_LEFT, 4: DIG_RIGHT, 5: SPLATTER
reg [5:0] fall_count; // counter for the number of clock cycles the Lemming has been falling
reg prev_direction; // the direction the Lemming was walking before it started falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        fall_count <= 0;
        prev_direction <= 0;
    end else begin
        case (state)
            0: begin // WALK_LEFT
                if (!ground) begin
                    state <= 2; // FALL
                    fall_count <= 1;
                    prev_direction <= 0;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (bump_left) begin
                    state <= 1; // WALK_RIGHT
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end else if (dig && !bump_left) begin
                    state <= 3; // DIG_LEFT
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else begin
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            1: begin // WALK_RIGHT
                if (!ground) begin
                    state <= 2; // FALL
                    fall_count <= 1;
                    prev_direction <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (bump_right) begin
                    state <= 0; // WALK_LEFT
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end else if (dig && !bump_right) begin
                    state <= 4; // DIG_RIGHT
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else begin
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            2: begin // FALL
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 5; // SPLATTER
                    end else begin
                        if (prev_direction) begin
                            state <= 1; // WALK_RIGHT
                            walk_left <= 0;
                            walk_right <= 1;
                            aaah <= 0;
                            digging <= 0;
                        end else begin
                            state <= 0; // WALK_LEFT
                            walk_left <= 1;
                            walk_right <= 0;
                            aaah <= 0;
                            digging <= 0;
                        end
                    end
                end else begin
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end
            end
            3: begin // DIG_LEFT
                if (!ground) begin
                    state <= 2; // FALL
                    fall_count <= 1;
                    prev_direction <= 0;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig) begin
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else begin
                    state <= 0; // WALK_LEFT
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            4: begin // DIG_RIGHT
                if (!ground) begin
                    state <= 2; // FALL
                    fall_count <= 1;
                    prev_direction <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig) begin
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else begin
                    state <= 1; // WALK_RIGHT
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            5: begin // SPLATTER
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule