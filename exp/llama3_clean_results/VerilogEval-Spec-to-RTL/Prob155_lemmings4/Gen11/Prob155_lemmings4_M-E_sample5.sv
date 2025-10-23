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

// Define the top-level states
enum logic [1:0] {
    WALKING = 2'b00,
    NON_WALKING = 2'b01
} top_state, next_top_state;

// Define the bottom-level states
enum logic [2:0] {
    LEFT = 3'b000,
    RIGHT = 3'b001,
    FALLING = 3'b010,
    DIGGING = 3'b011,
    SPLATTERED = 3'b100
} bottom_state, next_bottom_state;

// Define the walking direction
reg walking_direction;

// Define the fall counter
reg [4:0] fall_counter;

// Update the states
always @(posedge clk or posedge areset) begin
    if (areset) begin
        top_state <= WALKING;
        bottom_state <= LEFT;
        walking_direction <= 1'b0;
        fall_counter <= 5'b0;
    end else begin
        top_state <= next_top_state;
        bottom_state <= next_bottom_state;
        if (top_state == NON_WALKING && bottom_state == FALLING) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'b0;
        end
    end
end

// Calculate the next states
always @(*) begin
    case (top_state)
        WALKING: begin
            case (bottom_state)
                LEFT: begin
                    if (!ground) begin
                        next_top_state = NON_WALKING;
                        next_bottom_state = FALLING;
                    end else if (dig) begin
                        next_top_state = NON_WALKING;
                        next_bottom_state = DIGGING;
                    end else if (bump_left) begin
                        next_top_state = WALKING;
                        next_bottom_state = RIGHT;
                    end else if (bump_right) begin
                        next_top_state = WALKING;
                        next_bottom_state = RIGHT;
                    end else begin
                        next_top_state = WALKING;
                        next_bottom_state = LEFT;
                    end
                end
                RIGHT: begin
                    if (!ground) begin
                        next_top_state = NON_WALKING;
                        next_bottom_state = FALLING;
                    end else if (dig) begin
                        next_top_state = NON_WALKING;
                        next_bottom_state = DIGGING;
                    end else if (bump_left) begin
                        next_top_state = WALKING;
                        next_bottom_state = LEFT;
                    end else if (bump_right) begin
                        next_top_state = WALKING;
                        next_bottom_state = LEFT;
                    end else begin
                        next_top_state = WALKING;
                        next_bottom_state = RIGHT;
                    end
                end
            endcase
        end
        NON_WALKING: begin
            case (bottom_state)
                FALLING: begin
                    if (ground) begin
                        if (fall_counter > 5'd20) begin
                            next_top_state = NON_WALKING;
                            next_bottom_state = SPLATTERED;
                        end else begin
                            next_top_state = WALKING;
                            if (walking_direction == 1'b0) begin
                                next_bottom_state = LEFT;
                            end else begin
                                next_bottom_state = RIGHT;
                            end
                        end
                    end else begin
                        next_top_state = NON_WALKING;
                        next_bottom_state = FALLING;
                    end
                end
                DIGGING: begin
                    if (!ground) begin
                        next_top_state = NON_WALKING;
                        next_bottom_state = FALLING;
                    end else if (!dig) begin
                        next_top_state = WALKING;
                        if (walking_direction == 1'b0) begin
                            next_bottom_state = LEFT;
                        end else begin
                            next_bottom_state = RIGHT;
                        end
                    end else begin
                        next_top_state = NON_WALKING;
                        next_bottom_state = DIGGING;
                    end
                end
                SPLATTERED: begin
                    next_top_state = NON_WALKING;
                    next_bottom_state = SPLATTERED;
                end
            endcase
        end
    endcase
end

// Assign the outputs
assign walk_left = (top_state == WALKING && bottom_state == LEFT);
assign walk_right = (top_state == WALKING && bottom_state == RIGHT);
assign aaah = (top_state == NON_WALKING && bottom_state == FALLING);
assign digging = (top_state == NON_WALKING && bottom_state == DIGGING);

// Update the walking direction
always @(posedge clk) begin
    if (top_state == WALKING && bottom_state == LEFT) begin
        walking_direction <= 1'b0;
    end else if (top_state == WALKING && bottom_state == RIGHT) begin
        walking_direction <= 1'b1;
    end
end

endmodule