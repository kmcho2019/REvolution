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

reg [2:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALL, 3: DIG, 4: SPLATTER
reg [5:0] fall_counter; // counter for the number of clock cycles the Lemming has been falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // WALK_LEFT
        fall_counter <= 0;
    end else begin
        case (state)
            0: begin // WALK_LEFT
                if (!ground) begin
                    state <= 2; // FALL
                    fall_counter <= 1;
                end else if (dig && ground) begin
                    state <= 3; // DIG
                end else if (bump_right) begin
                    state <= 1; // WALK_RIGHT
                end
            end
            1: begin // WALK_RIGHT
                if (!ground) begin
                    state <= 2; // FALL
                    fall_counter <= 1;
                end else if (dig && ground) begin
                    state <= 3; // DIG
                end else if (bump_left) begin
                    state <= 0; // WALK_LEFT
                end
            end
            2: begin // FALL
                if (ground && fall_counter > 20) begin
                    state <= 4; // SPLATTER
                end else if (ground) begin
                    if (state == 0) begin
                        state <= 0; // WALK_LEFT
                    end else begin
                        state <= 1; // WALK_RIGHT
                    end
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            3: begin // DIG
                if (!ground) begin
                    state <= 2; // FALL
                    fall_counter <= 1;
                end
            end
            4: begin // SPLATTER
                // do nothing
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // WALK_LEFT
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin // WALK_RIGHT
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        2: begin // FALL
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        3: begin // DIG
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        4: begin // SPLATTER
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule