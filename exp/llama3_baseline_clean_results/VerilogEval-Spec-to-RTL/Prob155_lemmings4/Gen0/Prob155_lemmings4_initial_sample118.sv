module TopModule (
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

reg [2:0] state; // 0: Walking left, 1: Walking right, 2: Falling, 3: Digging, 4: Splattered
reg [4:0] fall_count; // Count of clock cycles since the Lemming started falling
reg walk_dir; // Direction the Lemming was walking before it fell or started digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        walk_dir <= 0;
        fall_count <= 0;
    end else begin
        case (state)
            0: begin // Walking left
                if (!ground) begin
                    state <= 2;
                    walk_dir <= 0;
                    fall_count <= 1;
                end else if (dig) begin
                    state <= 3;
                    walk_dir <= 0;
                end else if (bump_right) begin
                    state <= 1;
                end else if (bump_left) begin
                    state <= 0;
                end
            end
            1: begin // Walking right
                if (!ground) begin
                    state <= 2;
                    walk_dir <= 1;
                    fall_count <= 1;
                end else if (dig) begin
                    state <= 3;
                    walk_dir <= 1;
                end else if (bump_left) begin
                    state <= 0;
                end else if (bump_right) begin
                    state <= 1;
                end
            end
            2: begin // Falling
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4;
                    end else begin
                        state <= walk_dir ? 1 : 0;
                    end
                    fall_count <= 0;
                end else begin
                    fall_count <= fall_count + 1;
                end
            end
            3: begin // Digging
                if (!ground) begin
                    state <= 2;
                    fall_count <= 1;
                end
            end
            4: begin // Splattered
                // Do nothing
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // Walking left
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin // Walking right
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        2: begin // Falling
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        3: begin // Digging
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        4: begin // Splattered
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule