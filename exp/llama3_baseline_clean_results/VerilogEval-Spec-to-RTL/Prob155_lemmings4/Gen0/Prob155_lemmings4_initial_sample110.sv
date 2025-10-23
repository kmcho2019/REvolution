module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
parameter WALK_LEFT = 3'b001;
parameter WALK_RIGHT = 3'b010;
parameter FALLING = 3'b011;
parameter DIGGING = 3'b100;
parameter SPLATTERED = 3'b101;

// Define the current state and next state
reg [2:0] state;
reg [2:0] next_state;

// Define the counter for the number of clock cycles the Lemming has been falling
reg [5:0] fall_counter;
reg [5:0] next_fall_counter;

// Define the output signals
reg walk_left_out;
reg walk_right_out;
reg aaah_out;
reg digging_out;

// Assign the output signals based on the current state
always @(*) begin
    case(state)
        WALK_LEFT: begin
            walk_left_out = 1;
            walk_right_out = 0;
            aaah_out = 0;
            digging_out = 0;
        end
        WALK_RIGHT: begin
            walk_left_out = 0;
            walk_right_out = 1;
            aaah_out = 0;
            digging_out = 0;
        end
        FALLING: begin
            walk_left_out = 0;
            walk_right_out = 0;
            aaah_out = 1;
            digging_out = 0;
        end
        DIGGING: begin
            walk_left_out = 0;
            walk_right_out = 0;
            aaah_out = 0;
            digging_out = 1;
        end
        SPLATTERED: begin
            walk_left_out = 0;
            walk_right_out = 0;
            aaah_out = 0;
            digging_out = 0;
        end
        default: begin
            walk_left_out = 0;
            walk_right_out = 0;
            aaah_out = 0;
            digging_out = 0;
        end
    endcase
end

// Assign the next state and next fall counter based on the current state and input signals
always @(*) begin
    next_state = state;
    next_fall_counter = fall_counter;
    
    case(state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                // No change
            end else if (!ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                // No change
            end else if (!ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            next_fall_counter = fall_counter + 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = state == WALK_LEFT ? WALK_LEFT : WALK_RIGHT;
                end
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end
        end
        SPLATTERED: begin
            // No change
        end
        default: begin
            // No change
        end
    endcase
end

// Update the current state and fall counter on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
    end
end

// Assign the output signals
assign walk_left = walk_left_out;
assign walk_right = walk_right_out;
assign aaah = aaah_out;
assign digging = digging_out;

endmodule