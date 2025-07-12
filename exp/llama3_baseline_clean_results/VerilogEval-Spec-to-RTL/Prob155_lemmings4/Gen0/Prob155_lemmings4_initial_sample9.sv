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

reg [2:0] state; // 0: IDLE, 1: WALK_LEFT, 2: WALK_RIGHT, 3: FALLING, 4: DIGGING, 5: SPLATTERED
reg [5:0] fall_count; // counter to track the number of clock cycles the Lemming has been falling
reg was_digging; // flag to remember if the Lemming was digging before falling

// define the state transitions and output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // reset to WALK_LEFT state
        fall_count <= 0;
        was_digging <= 0;
    end else begin
        case (state)
            1: begin // WALK_LEFT state
                if (!ground) begin
                    state <= 3; // transition to FALLING state
                    fall_count <= 1;
                end else if (dig) begin
                    state <= 4; // transition to DIGGING state
                    was_digging <= 1;
                end else if (bump_left) begin
                    state <= 2; // transition to WALK_RIGHT state
                end
            end
            2: begin // WALK_RIGHT state
                if (!ground) begin
                    state <= 3; // transition to FALLING state
                    fall_count <= 1;
                end else if (dig) begin
                    state <= 4; // transition to DIGGING state
                    was_digging <= 1;
                end else if (bump_right) begin
                    state <= 1; // transition to WALK_LEFT state
                end
            end
            3: begin // FALLING state
                fall_count <= fall_count + 1;
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 5; // transition to SPLATTERED state
                    end else begin
                        if (was_digging) begin
                            was_digging <= 0;
                            state <= (state == 3) ? 1 : 2; // resume walking in the original direction
                        end else begin
                            state <= (state == 3) ? 1 : 2; // resume walking in the original direction
                        end
                    end
                    fall_count <= 0;
                end
            end
            4: begin // DIGGING state
                if (!ground) begin
                    state <= 3; // transition to FALLING state
                    fall_count <= 1;
                    was_digging <= 0;
                end
            end
            5: begin // SPLATTERED state
                // do nothing, stay in this state
            end
        endcase
    end
end

// output logic
always @(*) begin
    case (state)
        1: begin // WALK_LEFT state
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        2: begin // WALK_RIGHT state
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        3: begin // FALLING state
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        4: begin // DIGGING state
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        5: begin // SPLATTERED state
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule