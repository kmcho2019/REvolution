module TopModule (
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

reg [2:0] state; // 0: Walking Left, 1: Walking Right, 2: Falling, 3: Digging, 4: Splattered
reg [5:0] fall_count; // count the number of clock cycles the Lemming has been falling
reg walk_dir; // 0: Left, 1: Right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Walking Left
        walk_dir <= 0; // Left
        fall_count <= 0;
    end else begin
        case (state)
            0: begin // Walking Left
                if (~ground) begin
                    state <= 2; // Falling
                    walk_dir <= 0; // Left
                end else if (dig) begin
                    state <= 3; // Digging
                end else if (bump_right) begin
                    state <= 1; // Walking Right
                    walk_dir <= 1; // Right
                end else if (bump_left) begin
                    state <= 1; // Walking Right
                    walk_dir <= 1; // Right
                end
            end
            1: begin // Walking Right
                if (~ground) begin
                    state <= 2; // Falling
                    walk_dir <= 1; // Right
                end else if (dig) begin
                    state <= 3; // Digging
                end else if (bump_left) begin
                    state <= 0; // Walking Left
                    walk_dir <= 0; // Left
                end else if (bump_right) begin
                    state <= 0; // Walking Left
                    walk_dir <= 0; // Left
                end
            end
            2: begin // Falling
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4; // Splattered
                    end else begin
                        state <= walk_dir ? 1 : 0; // Resume walking in the same direction
                    end
                    fall_count <= 0;
                end
            end
            3: begin // Digging
                if (~ground) begin
                    state <= 2; // Falling
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
        0: begin // Walking Left
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin // Walking Right
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