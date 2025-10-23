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
enum logic [2:0] {
    IDLE = 3'b000,
    WALKING = 3'b001,
    FALLING = 3'b010,
    DIGGING = 3'b011,
    SPLATTERED = 3'b100
} state, next_state;

// Define the sub-states for walking
enum logic {
    WALK_LEFT = 1'b0,
    WALK_RIGHT = 1'b1
} walking_direction, next_walking_direction;

// Define the fall counter
reg [4:0] fall_counter;

// Define the splattered signal
reg splattered;

// Update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        walking_direction <= WALK_LEFT;
        fall_counter <= 5'b0;
        splattered <= 1'b0;
    end else begin
        state <= next_state;
        walking_direction <= next_walking_direction;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
        splattered <= splattered || (state == FALLING && ground && fall_counter > 5'd20);
    end
end

// Calculate the next state
always @(*) begin
    case (state)
        IDLE: begin
            if (ground) begin
                next_state = WALKING;
                next_walking_direction = WALK_LEFT;
            end else begin
                next_state = IDLE;
                next_walking_direction = WALK_LEFT;
            end
        end
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
                next_walking_direction = walking_direction;
            end else if (dig) begin
                next_state = DIGGING;
                next_walking_direction = walking_direction;
            end else if (bump_left) begin
                next_state = WALKING;
                next_walking_direction = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALKING;
                next_walking_direction = WALK_LEFT;
            end else begin
                next_state = WALKING;
                next_walking_direction = walking_direction;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                    next_walking_direction = walking_direction;
                end else begin
                    next_state = WALKING;
                    next_walking_direction = walking_direction;
                end
            end else begin
                next_state = FALLING;
                next_walking_direction = walking_direction;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                next_walking_direction = walking_direction;
            end else if (!dig) begin
                next_state = WALKING;
                next_walking_direction = walking_direction;
            end else begin
                next_state = DIGGING;
                next_walking_direction = walking_direction;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
            next_walking_direction = walking_direction;
        end
    endcase
end

// Assign the outputs
assign walk_left = (state == WALKING && walking_direction == WALK_LEFT) && !splattered;
assign walk_right = (state == WALKING && walking_direction == WALK_RIGHT) && !splattered;
assign aaah = (state == FALLING) && !splattered;
assign digging = (state == DIGGING) && !splattered;

endmodule