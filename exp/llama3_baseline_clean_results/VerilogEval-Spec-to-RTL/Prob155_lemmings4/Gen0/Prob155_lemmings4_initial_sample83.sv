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

reg [1:0] state; // 00: Walking left, 01: Walking right, 10: Falling/Digging, 11: Splattered
reg [1:0] prev_state; // Store previous walking direction
reg [4:0] fall_count; // Counter for fall cycles

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to Walking left
        prev_state <= 2'b00; // Reset previous walking direction
        fall_count <= 5'b0; // Reset fall counter
    end else begin
        case (state)
            2'b00: begin // Walking left
                if (!ground) begin
                    state <= 2'b10; // Start falling
                    fall_count <= 5'b1; // Increment fall counter
                end else if (dig && ground) begin
                    state <= 2'b10; // Start digging
                end else if (bump_right) begin
                    state <= 2'b01; // Switch to Walking right
                end
            end
            2'b01: begin // Walking right
                if (!ground) begin
                    state <= 2'b10; // Start falling
                    fall_count <= 5'b1; // Increment fall counter
                end else if (dig && ground) begin
                    state <= 2'b10; // Start digging
                end else if (bump_left) begin
                    state <= 2'b00; // Switch to Walking left
                end
            end
            2'b10: begin // Falling/Digging
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        state <= 2'b11; // Splatter
                    end else begin
                        state <= prev_state; // Resume walking
                    end
                    fall_count <= 5'b0; // Reset fall counter
                end else begin
                    fall_count <= fall_count + 5'b1; // Increment fall counter
                end
            end
            2'b11: begin // Splattered
                // Do nothing, stay in this state
            end
            default: begin
                // Do nothing, should not happen
            end
        endcase
        if (state == 2'b10 && dig) begin
            prev_state <= state == 2'b00 ? 2'b00 : 2'b01; // Store previous walking direction
        end
    end
end

always @ (*) begin
    case (state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b10: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = dig ? 1'b1 : 1'b0;
        end
        2'b11: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        default: begin
            // Do nothing, should not happen
        end
    endcase
end

endmodule