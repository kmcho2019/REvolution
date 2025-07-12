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
parameter IDLE_LEFT = 4'd0;
parameter IDLE_RIGHT = 4'd1;
parameter FALLING = 4'd2;
parameter DIGGING = 4'd3;
parameter SPLATTERED = 4'd4;

// Define the state register
reg [3:0] state;
reg [3:0] next_state;

// Define the fall counter
reg [5:0] fall_counter;
reg [5:0] next_fall_counter;

// Define the direction
reg direction;
reg next_direction;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_counter <= 0;
        direction <= 1; // Initial direction is left
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
        direction <= next_direction;
    end
end

// Combinational logic
always @(*) begin
    next_state = state;
    next_fall_counter = fall_counter;
    next_direction = direction;

    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
                next_direction = 0; // Direction is right
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
                next_direction = 1; // Direction is left
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1;
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
                next_direction = 1; // Direction is left
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
                next_direction = 0; // Direction is right
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = (direction) ? IDLE_LEFT : IDLE_RIGHT;
                end
            end else begin
                next_fall_counter = fall_counter + 1;
            end
        end
        DIGGING: begin
            digging = 1;
            if (~ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            // Do nothing
        end
    endcase
end

endmodule