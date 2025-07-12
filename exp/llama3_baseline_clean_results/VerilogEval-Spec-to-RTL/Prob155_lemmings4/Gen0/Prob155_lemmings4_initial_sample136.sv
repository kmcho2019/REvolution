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

reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALL, 3: DIG, 4: SPLATTER
reg [5:0] fall_counter; // Counter for the number of clock cycles the Lemming has been falling
reg walk_dir; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Initialize to WALK_LEFT
        walk_dir <= 1'b0; // Initialize to walk left
        fall_counter <= 6'b0; // Reset fall counter
    end else begin
        case (state)
            2'b00: begin // WALK_LEFT
                if (~ground) begin
                    state <= 2'b10; // Transition to FALL
                    fall_counter <= 6'b1; // Start fall counter
                end else if (dig) begin
                    state <= 2'b11; // Transition to DIG
                end else if (bump_left) begin
                    state <= 2'b01; // Transition to WALK_RIGHT
                    walk_dir <= 1'b1; // Update walk direction
                end
            end
            2'b01: begin // WALK_RIGHT
                if (~ground) begin
                    state <= 2'b10; // Transition to FALL
                    fall_counter <= 6'b1; // Start fall counter
                end else if (dig) begin
                    state <= 2'b11; // Transition to DIG
                end else if (bump_right) begin
                    state <= 2'b00; // Transition to WALK_LEFT
                    walk_dir <= 1'b0; // Update walk direction
                end
            end
            2'b10: begin // FALL
                if (ground) begin
                    if (fall_counter > 6'd20) begin
                        state <= 2'b11; // Transition to SPLATTER
                    end else begin
                        if (walk_dir) begin
                            state <= 2'b01; // Transition to WALK_RIGHT
                        end else begin
                            state <= 2'b00; // Transition to WALK_LEFT
                        end
                    end
                    fall_counter <= 6'b0; // Reset fall counter
                end else begin
                    fall_counter <= fall_counter + 1'b1; // Increment fall counter
                end
            end
            2'b11: begin // DIG
                if (~ground) begin
                    state <= 2'b10; // Transition to FALL
                    fall_counter <= 6'b1; // Start fall counter
                end
            end
            default: begin // SPLATTER
                state <= 2'b11; // Stay in SPLATTER state
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin // WALK_LEFT
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b01: begin // WALK_RIGHT
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2'b10: begin // FALL
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        2'b11: begin // DIG or SPLATTER
            if (state == 2'b11) begin // DIG
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
            end else begin // SPLATTER
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
        end
        default: begin // Invalid state
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule