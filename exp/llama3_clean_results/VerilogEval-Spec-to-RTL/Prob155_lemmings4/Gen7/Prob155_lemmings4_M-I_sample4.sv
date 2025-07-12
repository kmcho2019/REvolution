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

// Define the states
enum logic [1:0] {
    WALKING = 2'b00,
    FALLING = 2'b01,
    DIGGING = 2'b10,
    SPLATTERED = 2'b11
} state, next_state;

// Define the walking direction
reg walking_direction;

// Define the fall counter
reg [4:0] fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_direction <= 1'b0; // walking left
        fall_counter <= 5'b0;
    end else begin
        state <= next_state;
        case (state)
            WALKING: begin
                if (!ground) begin
                    // Fall
                    next_state <= FALLING;
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    // Dig
                    next_state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    // Switch direction
                    walking_direction <= ~walking_direction;
                end else begin
                    next_state <= WALKING;
                end
            end
            FALLING: begin
                if (ground) begin
                    // Hit ground
                    if (fall_counter > 5'd20) begin
                        next_state <= SPLATTERED;
                    end else begin
                        next_state <= WALKING;
                    end
                    fall_counter <= 5'b0;
                end else begin
                    // Continue falling
                    next_state <= FALLING;
                    fall_counter <= fall_counter + 1'b1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    // Fall
                    next_state <= FALLING;
                    fall_counter <= 5'b1;
                end else if (!dig) begin
                    // Stop digging
                    next_state <= WALKING;
                end else begin
                    next_state <= DIGGING;
                end
            end
            SPLATTERED: begin
                // Stay in this state forever
                next_state <= SPLATTERED;
            end
        endcase
    end
end

always @* begin
    walk_left = (state == WALKING && walking_direction == 1'b0) || (state == DIGGING && walking_direction == 1'b0);
    walk_right = (state == WALKING && walking_direction == 1'b1) || (state == DIGGING && walking_direction == 1'b1);
    aaah = state == FALLING;
    digging = state == DIGGING;
end

endmodule