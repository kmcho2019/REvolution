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

reg [2:0] state; // 3-bit state encoding to represent all states
reg [4:0] fall_counter;
reg direction; // 1 for right, 0 for left

// State encoding:
// 3'd0: walking left
// 3'd1: walking right
// 3'd2: falling
// 3'd3: digging
// 3'd4: splattered

assign walk_left = (state == 3'd0);
assign walk_right = (state == 3'd1);
assign aaah = (state == 3'd2);
assign digging = (state == 3'd3);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'd0; // Initialize to walking left
        fall_counter <= 5'd0;
        direction <= 1'b0; // Initialize direction to left
    end else begin
        case (state)
            3'd0, 3'd1: begin // Walking left or right
                if (!ground) begin
                    state <= 3'd2; // Fall if no ground
                    fall_counter <= 5'd1;
                end else if (dig) begin
                    state <= 3'd3; // Start digging if dig signal is high
                end else if (bump_left && direction == 1'b0) begin
                    state <= 3'd1; // Switch direction if bumped from the left
                    direction <= 1'b1;
                end else if (bump_right && direction == 1'b1) begin
                    state <= 3'd0; // Switch direction if bumped from the right
                    direction <= 1'b0;
                end
            end
            3'd2: begin // Falling
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 3'd4; // Splatter if fallen for more than 20 clock cycles
                    end else begin
                        state <= (direction == 1'b0)? 3'd0 : 3'd1; // Resume walking
                    end
                    fall_counter <= 5'd0;
                end
            end
            3'd3: begin // Digging
                if (!ground) begin
                    state <= 3'd2; // Fall if digging and no ground
                    fall_counter <= 5'd1;
                end
            end
            3'd4: begin // Splattered
                // Stay in this state forever
            end
        endcase
    end
end

endmodule