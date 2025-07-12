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

reg [1:0] state; // 0: IDLE_LEFT, 1: IDLE_RIGHT, 2: FALLING, 3: DIGGING, 4: SPLATTERED
reg [5:0] fall_counter; // counter for the number of clock cycles the Lemming has been falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // IDLE_LEFT
        fall_counter <= 0;
    end else begin
        case (state)
            0: begin // IDLE_LEFT
                if (!ground) begin
                    state <= 2; // FALLING
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= 3; // DIGGING
                end else if (bump_left) begin
                    state <= 1; // IDLE_RIGHT
                end
            end
            1: begin // IDLE_RIGHT
                if (!ground) begin
                    state <= 2; // FALLING
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= 3; // DIGGING
                end else if (bump_right) begin
                    state <= 0; // IDLE_LEFT
                end
            end
            2: begin // FALLING
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4; // SPLATTERED
                    end else begin
                        case ({bump_left, bump_right})
                            2'b00: begin
                                if (state == 2) begin // previous state was FALLING
                                    if (dig) begin
                                        state <= 3; // DIGGING
                                    end else begin
                                        if (bump_left) begin
                                            state <= 1; // IDLE_RIGHT
                                        end else if (bump_right) begin
                                            state <= 0; // IDLE_LEFT
                                        end else begin
                                            if (state == 0) begin
                                                state <= 0; // IDLE_LEFT
                                            end else begin
                                                state <= 1; // IDLE_RIGHT
                                            end
                                        end
                                    end
                                end else begin
                                    state <= 0; // IDLE_LEFT
                                end
                            end
                            2'b01: state <= 0; // IDLE_LEFT
                            2'b10: state <= 1; // IDLE_RIGHT
                            2'b11: state <= 1; // IDLE_RIGHT
                        endcase
                        fall_counter <= 0;
                    end
                end
            end
            3: begin // DIGGING
                if (!ground) begin
                    state <= 2; // FALLING
                    fall_counter <= 1;
                end
            end
            4: begin // SPLATTERED
                // do nothing
            end
            default: state <= 0; // IDLE_LEFT
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // IDLE_LEFT
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        1: begin // IDLE_RIGHT
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        2: begin // FALLING
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        3: begin // DIGGING
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        4: begin // SPLATTERED
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