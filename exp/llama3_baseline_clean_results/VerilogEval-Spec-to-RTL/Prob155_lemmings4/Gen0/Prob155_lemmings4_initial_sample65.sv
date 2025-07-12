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

reg [2:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging, 4: splattered
reg [5:0] fall_counter; // counter for number of clock cycles the Lemming has been falling
reg original_direction; // original direction of the Lemming before falling or digging

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
        fall_counter <= 0;
        original_direction <= 1; // walking left
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (ground == 0) begin
                    state <= 2; // start falling
                    fall_counter <= 1;
                    original_direction <= 1; // walking left
                    aaah <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 0;
                end else if (dig == 1 && bump_left == 0 && bump_right == 0) begin
                    state <= 3; // start digging
                    original_direction <= 1; // walking left
                    digging <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                end else if (bump_left == 1) begin
                    state <= 1; // switch to walking right
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            1: begin // walking right
                if (ground == 0) begin
                    state <= 2; // start falling
                    fall_counter <= 1;
                    original_direction <= 0; // walking right
                    aaah <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 0;
                end else if (dig == 1 && bump_left == 0 && bump_right == 0) begin
                    state <= 3; // start digging
                    original_direction <= 0; // walking right
                    digging <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                end else if (bump_right == 1) begin
                    state <= 0; // switch to walking left
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            2: begin // falling
                fall_counter <= fall_counter + 1;
                if (ground == 1) begin
                    if (fall_counter > 20) begin
                        state <= 4; // splatter
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        if (original_direction == 1) begin
                            state <= 0; // resume walking left
                            walk_left <= 1;
                            walk_right <= 0;
                            aaah <= 0;
                            digging <= 0;
                        end else begin
                            state <= 1; // resume walking right
                            walk_left <= 0;
                            walk_right <= 1;
                            aaah <= 0;
                            digging <= 0;
                        end
                    end
                end
            end
            3: begin // digging
                if (ground == 0) begin
                    state <= 2; // start falling
                    fall_counter <= 1;
                    aaah <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 0;
                end
            end
            4: begin // splattered
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule