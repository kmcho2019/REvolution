module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [2:0] state; // 0: S_WALK_LEFT, 1: S_WALK_RIGHT, 2: S_FALL, 3: S_DIG, 4: S_SPLATTER
reg [5:0] fall_count; // count of clock cycles in the S_FALL state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        fall_count <= 0;
    end else begin
        case (state)
            0: begin // S_WALK_LEFT
                if (!ground) begin
                    state <= 2;
                    fall_count <= 1;
                end else if (dig) begin
                    state <= 3;
                end else if (bump_left) begin
                    state <= 1;
                end else if (bump_right) begin
                    // do nothing, already walking left
                end else begin
                    // do nothing, already walking left
                end
            end
            1: begin // S_WALK_RIGHT
                if (!ground) begin
                    state <= 2;
                    fall_count <= 1;
                end else if (dig) begin
                    state <= 3;
                end else if (bump_right) begin
                    state <= 0;
                end else if (bump_left) begin
                    // do nothing, already walking right
                end else begin
                    // do nothing, already walking right
                end
            end
            2: begin // S_FALL
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4;
                    end else begin
                        case (state_before_fall)
                            0: state <= 0;
                            1: state <= 1;
                            default: state <= 0;
                        endcase
                    end
                    fall_count <= 0;
                end else begin
                    fall_count <= fall_count + 1;
                end
            end
            3: begin // S_DIG
                if (!ground) begin
                    state <= 2;
                    fall_count <= 1;
                end else begin
                    // do nothing, still digging
                end
            end
            4: begin // S_SPLATTER
                // do nothing, already splattered
            end
            default: state <= 0;
        endcase
    end
end

reg [2:0] state_before_fall; // save the state before falling

always @(posedge clk) begin
    if (state == 2) begin
        case (state_before_fall)
            0: state_before_fall <= 0;
            1: state_before_fall <= 1;
            default: state_before_fall <= 0;
        endcase
    end else begin
        case (state)
            0: state_before_fall <= 0;
            1: state_before_fall <= 1;
            default: state_before_fall <= 0;
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // S_WALK_LEFT
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin // S_WALK_RIGHT
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        2: begin // S_FALL
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        3: begin // S_DIG
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        4: begin // S_SPLATTER
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule