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

reg [2:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING, 3: DIGGING_LEFT, 4: DIGGING_RIGHT, 5: SPLATTERED
reg [5:0] fall_count; // Counter for the number of clock cycles the Lemming has been falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to WALK_LEFT state
        fall_count <= 0; // Reset the fall counter
    end else begin
        case (state)
            0: begin // WALK_LEFT
                if (!ground) begin
                    state <= 2; // Transition to FALLING state
                    fall_count <= 1; // Start counting the fall time
                end else if (dig) begin
                    state <= 3; // Transition to DIGGING_LEFT state
                end else if (bump_right) begin
                    state <= 1; // Transition to WALK_RIGHT state
                end
            end
            1: begin // WALK_RIGHT
                if (!ground) begin
                    state <= 2; // Transition to FALLING state
                    fall_count <= 1; // Start counting the fall time
                end else if (dig) begin
                    state <= 4; // Transition to DIGGING_RIGHT state
                end else if (bump_left) begin
                    state <= 0; // Transition to WALK_LEFT state
                end
            end
            2: begin // FALLING
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 5; // Transition to SPLATTERED state
                    end else if (state == 2) begin // If not digging, restore original direction
                        if (bump_left) begin
                            state <= 0; // Transition to WALK_LEFT state
                        end else if (bump_right) begin
                            state <= 1; // Transition to WALK_RIGHT state
                        end else if (dig) begin
                            state <= 0; // Transition to WALK_LEFT state
                        end
                    end else begin // If digging, restore original direction
                        if (state == 2) begin // Not digging
                            if (bump_left) begin
                                state <= 0; // Transition to WALK_LEFT state
                            end else if (bump_right) begin
                                state <= 1; // Transition to WALK_RIGHT state
                            end
                        end else if (state == 3) begin // Digging left
                            state <= 0; // Transition to WALK_LEFT state
                        end else if (state == 4) begin // Digging right
                            state <= 1; // Transition to WALK_RIGHT state
                        end
                    end
                end else begin
                    fall_count <= fall_count + 1; // Increment the fall counter
                end
            end
            3: begin // DIGGING_LEFT
                if (!ground) begin
                    state <= 2; // Transition to FALLING state
                    fall_count <= 1; // Start counting the fall time
                end else if (bump_right) begin
                    state <= 4; // Transition to DIGGING_RIGHT state
                end
            end
            4: begin // DIGGING_RIGHT
                if (!ground) begin
                    state <= 2; // Transition to FALLING state
                    fall_count <= 1; // Start counting the fall time
                end else if (bump_left) begin
                    state <= 3; // Transition to DIGGING_LEFT state
                end
            end
            5: begin // SPLATTERED
                // Do nothing, stay in this state
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        2: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        3: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        4: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 1;
        end
        5: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule