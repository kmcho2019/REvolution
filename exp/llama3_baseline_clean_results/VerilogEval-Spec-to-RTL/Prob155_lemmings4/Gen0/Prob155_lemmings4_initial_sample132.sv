module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    input           ground,
    input           dig,
    output reg      walk_left,
    output reg      walk_right,
    output reg      aaah,
    output reg      digging
);

reg [5:0] fall_count; // Counter for fall time
reg current_state, next_state; // Current and next state
reg direction; // Walking direction (0 for left, 1 for right)

// States encoding
localparam IDLE_LEFT = 2'b00; // Walking left
localparam IDLE_RIGHT = 2'b01; // Walking right
localparam FALLING = 2'b10; // Falling
localparam DIGGING_LEFT = 2'b11; // Digging left
localparam DIGGING_RIGHT = 2'b11; // Digging right (same as digging left, but with different direction)
localparam SPLATTERED = 4'b1000; // Splattered

// Assign outputs based on current state
always @(*) begin
    walk_left = (current_state == IDLE_LEFT || (current_state == DIGGING_LEFT && ground == 1'b1)) ? 1'b1 : 1'b0;
    walk_right = (current_state == IDLE_RIGHT || (current_state == DIGGING_RIGHT && ground == 1'b1)) ? 1'b1 : 1'b0;
    aaah = (current_state == FALLING) ? 1'b1 : 1'b0;
    digging = (current_state == DIGGING_LEFT || current_state == DIGGING_RIGHT) ? 1'b1 : 1'b0;
end

// State machine logic
always @(posedge clk or posedge areset) begin
    if (areset) begin // Reset
        current_state <= IDLE_LEFT;
        direction <= 0;
        fall_count <= 0;
    end else begin
        case (current_state)
            IDLE_LEFT: begin
                if (bump_left) begin // Bumped left, walk right
                    current_state <= IDLE_RIGHT;
                    direction <= 1;
                end else if (bump_right) begin // Bumped right, walk left
                    // Do nothing, already walking left
                end else if (~ground) begin // No ground, fall
                    current_state <= FALLING;
                    fall_count <= 1;
                end else if (dig) begin // Start digging
                    current_state <= DIGGING_LEFT;
                end
            end
            IDLE_RIGHT: begin
                if (bump_right) begin // Bumped right, walk left
                    current_state <= IDLE_LEFT;
                    direction <= 0;
                end else if (bump_left) begin // Bumped left, walk right
                    // Do nothing, already walking right
                end else if (~ground) begin // No ground, fall
                    current_state <= FALLING;
                    fall_count <= 1;
                end else if (dig) begin // Start digging
                    current_state <= DIGGING_RIGHT;
                end
            end
            FALLING: begin
                fall_count <= fall_count + 1;
                if (ground) begin // Hit ground
                    if (fall_count > 20) begin // Splattered
                        current_state <= SPLATTERED;
                    end else begin // Continue walking
                        if (direction == 0) begin
                            current_state <= IDLE_LEFT;
                        end else begin
                            current_state <= IDLE_RIGHT;
                        end
                    end
                end
            end
            DIGGING_LEFT, DIGGING_RIGHT: begin
                if (~ground) begin // No ground, fall
                    current_state <= FALLING;
                    fall_count <= 1;
                end else if (~dig) begin // Stop digging
                    if (direction == 0) begin
                        current_state <= IDLE_LEFT;
                    end else begin
                        current_state <= IDLE_RIGHT;
                    end
                end
            end
            default: begin // SPLATTERED
                current_state <= SPLATTERED;
            end
        endcase
    end
end

endmodule