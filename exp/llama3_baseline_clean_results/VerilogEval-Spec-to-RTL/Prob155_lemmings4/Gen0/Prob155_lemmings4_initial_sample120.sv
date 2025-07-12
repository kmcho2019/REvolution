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
parameter WALKING_LEFT = 0;
parameter WALKING_RIGHT = 1;
parameter FALLING = 2;
parameter DIGGING = 3;
parameter DEAD = 4;

// Define the state register
reg [2:0] state;
reg [2:0] nextState;

// Define the direction register
reg direction;

// Define the fall counter
reg [5:0] fall_counter;
reg [5:0] next_fall_counter;

// Define the original direction when falling or digging
reg original_direction;

// Define the output signals
reg walk_left_out;
reg walk_right_out;
reg aaah_out;
reg digging_out;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING_LEFT;
        direction <= 0; // 0 for left, 1 for right
        fall_counter <= 0;
        original_direction <= 0;
    end else begin
        state <= nextState;
        direction <= direction;
        fall_counter <= next_fall_counter;
        original_direction <= original_direction;
    end
end

// Combinational logic
always @(*) begin
    // Initialize output signals
    walk_left_out = 0;
    walk_right_out = 0;
    aaah_out = 0;
    digging_out = 0;

    // Initialize next state and counter
    nextState = state;
    next_fall_counter = fall_counter;

    case (state)
        WALKING_LEFT: begin
            walk_left_out = 1;
            if (~ground) begin
                nextState = FALLING;
                original_direction = direction;
            end else if (dig) begin
                nextState = DIGGING;
            end else if (bump_left) begin
                nextState = WALKING_RIGHT;
                direction = 1;
            end else if (bump_right) begin
                // Do nothing
            end
        end

        WALKING_RIGHT: begin
            walk_right_out = 1;
            if (~ground) begin
                nextState = FALLING;
                original_direction = direction;
            end else if (dig) begin
                nextState = DIGGING;
            end else if (bump_right) begin
                nextState = WALKING_LEFT;
                direction = 0;
            end else if (bump_left) begin
                // Do nothing
            end
        end

        FALLING: begin
            aaah_out = 1;
            next_fall_counter = fall_counter + 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    nextState = DEAD;
                end else begin
                    nextState = WALKING_LEFT;
                    direction = original_direction;
                end
            end
        end

        DIGGING: begin
            digging_out = 1;
            if (~ground) begin
                nextState = FALLING;
            end
        end

        DEAD: begin
            // Do nothing
        end

    endcase
end

// Assign output signals
assign walk_left = walk_left_out;
assign walk_right = walk_right_out;
assign aaah = aaah_out;
assign digging = digging_out;

endmodule