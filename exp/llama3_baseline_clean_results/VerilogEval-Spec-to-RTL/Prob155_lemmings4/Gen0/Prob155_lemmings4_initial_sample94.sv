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

reg [2:0] state; // 0: Idle, 1: Walking Left, 2: Walking Right, 3: Falling, 4: Digging, 5: Splattered
reg [5:0] fall_counter; // Counter for the number of clock cycles the Lemming has been falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // Reset to Walking Left state
        fall_counter <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            1: begin // Walking Left
                if (~ground) begin
                    state <= 3; // Transition to Falling state
                    fall_counter <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig) begin
                    state <= 4; // Transition to Digging state
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_left) begin
                    state <= 2; // Transition to Walking Right state
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_right) begin
                    // No change
                end else begin
                    // No change
                end
            end
            2: begin // Walking Right
                if (~ground) begin
                    state <= 3; // Transition to Falling state
                    fall_counter <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else if (dig) begin
                    state <= 4; // Transition to Digging state
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_right) begin
                    state <= 1; // Transition to Walking Left state
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end else if (bump_left) begin
                    // No change
                end else begin
                    // No change
                end
            end
            3: begin // Falling
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 5; // Transition to Splattered state
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else if (state == 3) begin
                        state <= 1; // Transition to Walking Left state if previously walking left
                        walk_left <= 1;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        state <= 2; // Transition to Walking Right state if previously walking right
                        walk_left <= 0;
                        walk_right <= 1;
                        aaah <= 0;
                        digging <= 0;
                    end
                end else begin
                    fall_counter <= fall_counter + 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end
            end
            4: begin // Digging
                if (~ground) begin
                    state <= 3; // Transition to Falling state
                    fall_counter <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                end else begin
                    // No change
                end
            end
            5: begin // Splattered
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule