module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [2:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING, 3: DIGGING, 4: SPLATTERED
reg [5:0] fall_counter; // counter to track number of clock cycles Lemming has been falling
reg direction; // direction the Lemming was walking before falling or digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to WALK_LEFT state
        fall_counter <= 0;
        direction <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            0: begin // WALK_LEFT state
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
                if (bump_right) begin
                    state <= 1; // transition to WALK_RIGHT state
                    direction <= 1;
                end else if (bump_left) begin
                    // do nothing, already walking left
                end else if (dig && ground) begin
                    state <= 3; // transition to DIGGING state
                    direction <= 0;
                end else if (!ground) begin
                    state <= 2; // transition to FALLING state
                    fall_counter <= 1;
                end
            end
            1: begin // WALK_RIGHT state
                walk_left <= 0;
                walk_right <= 1;
                aaah <= 0;
                digging <= 0;
                if (bump_left) begin
                    state <= 0; // transition to WALK_LEFT state
                    direction <= 0;
                end else if (bump_right) begin
                    // do nothing, already walking right
                end else if (dig && ground) begin
                    state <= 3; // transition to DIGGING state
                    direction <= 1;
                end else if (!ground) begin
                    state <= 2; // transition to FALLING state
                    fall_counter <= 1;
                end
            end
            2: begin // FALLING state
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
                digging <= 0;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4; // transition to SPLATTERED state
                    end else begin
                        state <= {direction, 2'b00}; // transition back to walking state
                    end
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            3: begin // DIGGING state
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 1;
                if (!ground) begin
                    state <= 2; // transition to FALLING state
                    fall_counter <= 1;
                end
            end
            4: begin // SPLATTERED state
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule