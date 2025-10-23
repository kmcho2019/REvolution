module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [2:0] state; // WALKING_LEFT (0), WALKING_RIGHT (1), FALLING (2), DIGGING (3), SPLATTERED (4)
reg [4:0] fall_counter; // counter for falling state
reg current_direction; // 0 for left, 1 for right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b000; // WALKING_LEFT
        fall_counter <= 5'b0;
        current_direction <= 1'b0; // walking left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // WALKING_LEFT
                if (!ground) begin
                    state <= 3'b010; // FALLING
                    fall_counter <= 5'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    state <= 3'b100; // DIGGING
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left) begin
                    state <= 3'b001; // WALKING_RIGHT
                    current_direction <= 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else if (bump_right) begin
                    state <= 3'b000; // WALKING_LEFT
                    current_direction <= 1'b0;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else if (bump_left && bump_right) begin
                    state <= 3'b001; // WALKING_RIGHT
                    current_direction <= 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            end
            3'b001: begin // WALKING_RIGHT
                if (!ground) begin
                    state <= 3'b010; // FALLING
                    fall_counter <= 5'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    state <= 3'b100; // DIGGING
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left) begin
                    state <= 3'b000; // WALKING_LEFT
                    current_direction <= 1'b0;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else if (bump_right) begin
                    state <= 3'b001; // WALKING_RIGHT
                    current_direction <= 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else if (bump_left && bump_right) begin
                    state <= 3'b000; // WALKING_LEFT
                    current_direction <= 1'b0;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            end
            3'b010: begin // FALLING
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 3'b100; // SPLATTERED
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                    end else begin
                        if (current_direction == 1'b0) begin
                            state <= 3'b000; // WALKING_LEFT
                            walk_left <= 1'b1;
                            walk_right <= 1'b0;
                            aaah <= 1'b0;
                            digging <= 1'b0;
                        end else begin
                            state <= 3'b001; // WALKING_RIGHT
                            walk_left <= 1'b0;
                            walk_right <= 1'b1;
                            aaah <= 1'b0;
                            digging <= 1'b0;
                        end
                    end
                    fall_counter <= 5'b0;
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                end
                aaah <= 1'b1;
            end
            3'b100: begin // DIGGING
                if (!ground) begin
                    state <= 3'b010; // FALLING
                    fall_counter <= 5'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else begin
                    if (current_direction == 1'b0) begin
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b1;
                    end else begin
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b1;
                    end
                end
            end
            3'b111: begin // SPLATTERED
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule