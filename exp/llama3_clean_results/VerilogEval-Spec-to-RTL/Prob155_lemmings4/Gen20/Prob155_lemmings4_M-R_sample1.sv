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

// Define the states of the Lemming
enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Counter to track the number of clock cycles the Lemming has been falling
reg [4:0] fall_counter;

// Variable to track the walking direction of the Lemming
reg walking_direction;

// Variable to track whether the Lemming has been splattered
reg splattered;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        // Reset the state machine to the walking state with left direction
        state <= WALKING;
        fall_counter <= 5'b0;
        walking_direction <= 1'b1; // walking left
        splattered <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                if (~ground) begin
                    // If the ground is not present, the Lemming starts falling
                    next_state <= FALLING;
                end else if (dig) begin
                    // If the dig input is high, the Lemming starts digging
                    next_state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    // If the Lemming is bumped, it changes direction
                    walking_direction <= ~walking_direction;
                    next_state <= WALKING;
                end else begin
                    // Otherwise, the Lemming continues walking
                    next_state <= WALKING;
                end
            end
            FALLING: begin
                // Increment the fall counter
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    // If the ground is present, the Lemming stops falling
                    if (fall_counter > 5'd20) begin
                        // If the Lemming has been falling for more than 20 clock cycles, it splatters
                        next_state <= SPLATTERED;
                        splattered <= 1'b1;
                    end else begin
                        // Otherwise, the Lemming resumes walking
                        next_state <= WALKING;
                    end
                    // Reset the fall counter
                    fall_counter <= 5'b0;
                end else begin
                    // Otherwise, the Lemming continues falling
                    next_state <= FALLING;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    // If the ground is not present, the Lemming stops digging and starts falling
                    next_state <= FALLING;
                end else begin
                    // Otherwise, the Lemming continues digging
                    next_state <= DIGGING;
                end
            end
            SPLATTERED: begin
                // The Lemming remains splattered
                next_state <= SPLATTERED;
            end
        endcase
        // Update the state
        state <= next_state;
    end
end

assign walk_left = (state == WALKING && walking_direction) || (state == DIGGING && walking_direction);
assign walk_right = (state == WALKING && ~walking_direction) || (state == DIGGING && ~walking_direction);
assign aaah = state == FALLING;
assign digging = state == DIGGING && !splattered;

endmodule