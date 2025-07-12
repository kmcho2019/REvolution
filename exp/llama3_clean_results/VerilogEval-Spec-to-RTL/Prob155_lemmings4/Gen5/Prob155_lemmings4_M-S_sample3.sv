module TopModule (
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

reg [2:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging, 4: splattered
reg [4:0] fall_counter; // counter for falling
reg direction; // 1 for right, 0 for left

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize to walking left
        fall_counter <= 0;
        direction <= 0; // Initialize direction to left
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
    end else begin
        case (state)
            0, 1: begin // Walking left or right
                walk_left <= (state == 0);
                walk_right <= (state == 1);
                aaah <= 0;
                digging <= 0;
                if (!ground) begin
                    state <= 2; // Fall if no ground
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= 3; // Start digging if dig signal is high
                end else if (bump_left && state == 1) begin
                    state <= 0; // Switch direction if bumped from the left
                    direction <= 0;
                end else if (bump_right && state == 0) begin
                    state <= 1; // Switch direction if bumped from the right
                    direction <= 1;
                end else if (bump_left && state == 0) begin
                    state <= 1; // Switch direction if bumped from the left while walking left
                    direction <= 1;
                end else if (bump_right && state == 1) begin
                    state <= 0; // Switch direction if bumped from the right while walking right
                    direction <= 0;
                end
            end
            2: begin // Falling
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
                digging <= 0;
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= 4; // Splatter if fallen for more than 20 clock cycles
                    end else begin
                        state <= (direction == 0)? 0 : 1; // Resume walking
                    end
                    fall_counter <= 0;
                end
            end
            3: begin // Digging
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 1;
                if (!ground) begin
                    state <= 2; // Fall if digging and no ground
                    fall_counter <= 1;
                end
            end
            4: begin // Splattered
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule