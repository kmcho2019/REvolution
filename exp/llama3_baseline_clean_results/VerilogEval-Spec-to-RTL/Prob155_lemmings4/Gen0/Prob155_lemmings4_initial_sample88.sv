module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
parameter IDLE_LEFT = 4'b0000;
parameter IDLE_RIGHT = 4'b0001;
parameter FALLING = 4'b0010;
parameter DIGGING = 4'b0011;
parameter SPLATTERED = 4'b0100;

// Define the current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Define the walking direction
reg walk_direction;

// Define the fall counter
reg [5:0] fall_counter;

// Initialize the current state to IDLE_LEFT
initial current_state = IDLE_LEFT;

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= IDLE_LEFT;
        walk_direction <= 1'b0;
        fall_counter <= 6'b000000;
    end else begin
        current_state <= next_state;
    end
end

// Determine the next state
always @(*) begin
    case (current_state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 6'b101000) begin
                    next_state = SPLATTERED;
                end else begin
                    if (walk_direction == 1'b0) begin
                        next_state = IDLE_LEFT;
                    end else begin
                        next_state = IDLE_RIGHT;
                    end
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
        default: begin
            next_state = IDLE_LEFT;
        end
    endcase
end

// Update the outputs
always @(*) begin
    case (current_state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            walk_direction = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            walk_direction = 1'b1;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

// Update the fall counter
always @(posedge clk) begin
    if (current_state == FALLING) begin
        fall_counter <= fall_counter + 1'b1;
    end else begin
        fall_counter <= 6'b000000;
    end
end

endmodule