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

// Enum for states
enum logic [2:0] {
    WALK_LEFT = 3'd0,
    WALK_RIGHT = 3'd1,
    FALLING = 3'd2,
    DIGGING = 3'd3,
    SPLATTERED = 3'd4
} state, next_state;

reg [4:0] fall_counter;
reg direction; // 1 for right, 0 for left

// Output assignments
assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT; // Initialize to walking left
        fall_counter <= 5'd0;
        direction <= 1'b0; // Initialize direction to left
    end else begin
        case (state)
            WALK_LEFT, WALK_RIGHT: begin // Walking left or right
                if (!ground) begin
                    next_state <= FALLING; // Fall if no ground
                    fall_counter <= 5'd1;
                end else if (dig) begin
                    next_state <= DIGGING; // Start digging if dig signal is high
                end else if (bump_left && state == WALK_LEFT) begin
                    next_state <= WALK_RIGHT; // Switch direction if bumped from the left
                    direction <= 1'b1;
                end else if (bump_right && state == WALK_RIGHT) begin
                    next_state <= WALK_LEFT; // Switch direction if bumped from the right
                    direction <= 1'b0;
                end else if (bump_left && state == WALK_RIGHT) begin
                    next_state <= WALK_LEFT; // Switch direction if bumped from the left while walking right
                    direction <= 1'b0;
                end else if (bump_right && state == WALK_LEFT) begin
                    next_state <= WALK_RIGHT; // Switch direction if bumped from the right while walking left
                    direction <= 1'b1;
                end else begin
                    next_state <= state; // Stay in the same state
                end
            end
            FALLING: begin // Falling
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        next_state <= SPLATTERED; // Splatter if fallen for more than 20 clock cycles
                    end else begin
                        next_state <= (direction == 1'b0)? WALK_LEFT : WALK_RIGHT; // Resume walking
                    end
                    fall_counter <= 5'd0;
                end else begin
                    next_state <= FALLING; // Stay falling
                end
            end
            DIGGING: begin // Digging
                if (!ground) begin
                    next_state <= FALLING; // Fall if digging and no ground
                    fall_counter <= 5'd1;
                end else begin
                    next_state <= DIGGING; // Stay digging
                end
            end
            SPLATTERED: begin // Splattered
                // Stay in this state forever
                next_state <= SPLATTERED;
            end
        endcase
        state <= next_state; // Update state
    end
end

endmodule