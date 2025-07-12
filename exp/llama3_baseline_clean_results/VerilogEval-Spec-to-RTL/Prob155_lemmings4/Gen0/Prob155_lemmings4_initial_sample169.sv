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
localparam WALK_LEFT = 4'b0001;
localparam WALK_RIGHT = 4'b0010;
localparam FALLING = 4'b0100;
localparam DIGGING = 4'b1000;
localparam SPLATTERED = 4'b0000;

// Define the state register
reg [3:0] state;
reg [3:0] next_state;

// Define the counter for falling
reg [5:0] fall_counter;
reg [5:0] next_fall_counter;

// Define the direction register
reg walk_direction;
reg next_walk_direction;

// Moore state machine
always @(*) begin
    // Default values
    next_state = state;
    next_fall_counter = fall_counter;
    next_walk_direction = walk_direction;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (bump_left) begin
                next_state = WALK_RIGHT;
                next_walk_direction = 1'b0;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                next_walk_direction = 1'b1;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
                next_fall_counter = 1'b1;
            end
        end

        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (bump_right) begin
                next_state = WALK_LEFT;
                next_walk_direction = 1'b1;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
                next_walk_direction = 1'b0;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
                next_fall_counter = 1'b1;
            end
        end

        FALLING: begin
            aaah = 1'b1;
            next_fall_counter = fall_counter + 1'b1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = walk_direction ? WALK_LEFT : WALK_RIGHT;
                end
            end
        end

        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALLING;
                next_fall_counter = 1'b1;
            end
        end

        SPLATTERED: begin
            // Do nothing
        end

        default: begin
            // Do nothing
        end
    endcase
end

// Update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 6'b000000;
        walk_direction <= 1'b1;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
        walk_direction <= next_walk_direction;
    end
end

endmodule