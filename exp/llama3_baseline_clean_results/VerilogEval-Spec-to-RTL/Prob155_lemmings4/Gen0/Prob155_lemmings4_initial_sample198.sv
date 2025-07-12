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

reg [2:0] state; // 3-bit state register
reg [4:0] fall_counter; // 5-bit counter to count the number of clock cycles while falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to walking left state
        fall_counter <= 0;
    end else begin
        case (state)
            0: begin // Walking left
                if (~ground) begin
                    state <= 2; // Fall
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= 3; // Dig
                end else if (bump_left) begin
                    state <= 1; // Walk right
                end else if (bump_right) begin
                    // Stay in walking left state
                end
            end
            1: begin // Walking right
                if (~ground) begin
                    state <= 2; // Fall
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= 3; // Dig
                end else if (bump_right) begin
                    state <= 0; // Walk left
                end else if (bump_left) begin
                    // Stay in walking right state
                end
            end
            2: begin // Falling
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4; // Splatter
                    end else begin
                        // Check the previous state to determine the direction
                        if (state == 0 || state == 3) begin
                            state <= 0; // Walk left
                        end else begin
                            state <= 1; // Walk right
                        end
                    end
                end else begin
                    state <= 2; // Continue falling
                    fall_counter <= fall_counter + 1;
                end
            end
            3: begin // Digging
                if (~ground) begin
                    state <= 2; // Fall
                    fall_counter <= 1;
                end else begin
                    // Continue digging
                end
            end
            4: begin // Splatter
                // Stay in splatter state
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
        4: begin // Splatter
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule