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

// Define the walking state machine
enum logic {
    WALK_LEFT = 1'b0,
    WALK_RIGHT = 1'b1
} walk_state, next_walk_state;

// Update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_state <= WALK_LEFT;
        walking_direction <= 1'b0;
        fall_counter <= 5'b0;
    end else begin
        state <= next_state;
        walk_state <= next_walk_state;
        walking_direction <= walk_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
    end
end

// Calculate the next state
always @(*) begin
    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_state = WALKING;
            end else begin
                next_state = WALKING;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (!dig) begin
                next_state = WALKING;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

// Calculate the next walk state
always @(*) begin
    case (walk_state)
        WALK_LEFT: begin
            if (bump_left || bump_right) begin
                next_walk_state = WALK_RIGHT;
            end else begin
                next_walk_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_left || bump_right) begin
                next_walk_state = WALK_LEFT;
            end else begin
                next_walk_state = WALK_RIGHT;
            end
        end
    endcase
end

// Assign the outputs
assign walk_left = (state == WALKING && walk_state == WALK_LEFT) || (state == DIGGING && walk_state == WALK_LEFT);
assign walk_right = (state == WALKING && walk_state == WALK_RIGHT) || (state == DIGGING && walk_state == WALK_RIGHT);
assign aaah = state == FALLING;
assign digging = state == DIGGING;

endmodule