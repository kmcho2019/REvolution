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

reg [2:0] state; // 0: IDLE_LEFT, 1: IDLE_RIGHT, 2: FALLING, 3: DIGGING, 4: SPLATTERED
reg [5:0] fall_counter; // Counter to track how long the Lemming has been falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to IDLE_LEFT state
        fall_counter <= 0;
    end else begin
        case (state)
            0: begin // IDLE_LEFT
                if (!ground) begin
                    state <= 2; // Transition to FALLING state
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= 3; // Transition to DIGGING state
                end else if (bump_right) begin
                    state <= 1; // Switch to IDLE_RIGHT state
                end
            end
            1: begin // IDLE_RIGHT
                if (!ground) begin
                    state <= 2; // Transition to FALLING state
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= 3; // Transition to DIGGING state
                end else if (bump_left) begin
                    state <= 0; // Switch to IDLE_LEFT state
                end
            end
            2: begin // FALLING
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4; // Transition to SPLATTERED state
                    end else begin
                        state <= (state == 0) ? 0 : 1; // Resume walking in the same direction
                    end
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            3: begin // DIGGING
                if (!ground) begin
                    state <= 2; // Transition to FALLING state
                    fall_counter <= 1;
                end
            end
            4: begin // SPLATTERED
                // Do nothing, stay in this state forever
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
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        4: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule