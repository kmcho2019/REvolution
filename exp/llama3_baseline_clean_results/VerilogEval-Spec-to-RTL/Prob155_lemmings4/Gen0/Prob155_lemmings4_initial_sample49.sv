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
parameter WALK_LEFT = 4'b0001;
parameter WALK_RIGHT = 4'b0010;
parameter FALLING = 4'b0100;
parameter DIGGING = 4'b1000;
parameter SPLATTERED = 4'b0000;

// Define the current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Define the counter for the number of clock cycles the Lemming has been falling
reg [5:0] fall_counter;
reg [5:0] next_fall_counter;

// Define the initial state
initial current_state = WALK_LEFT;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
        fall_counter <= 6'b000000;
    end
    else begin
        current_state <= next_state;
        fall_counter <= next_fall_counter;
    end
end

// Combinational logic
always @(*) begin
    // Default values
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    // Determine the next state and fall counter
    next_state = current_state;
    next_fall_counter = fall_counter;

    case (current_state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
                aaah = 1;
            end
            else if (dig) begin
                next_state = DIGGING;
                digging = 1;
            end
            else if (bump_left) begin
                next_state = WALK_RIGHT;
            end
            else if (bump_right) begin
                // No change
            end
            walk_left = 1;
        end

        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
                aaah = 1;
            end
            else if (dig) begin
                next_state = DIGGING;
                digging = 1;
            end
            else if (bump_right) begin
                next_state = WALK_LEFT;
            end
            else if (bump_left) begin
                // No change
            end
            walk_right = 1;
        end

        FALLING: begin
            next_fall_counter = fall_counter + 1;
            aaah = 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end
                else begin
                    if (current_state == WALK_LEFT) begin
                        next_state = WALK_LEFT;
                        walk_left = 1;
                    end
                    else if (current_state == WALK_RIGHT) begin
                        next_state = WALK_RIGHT;
                        walk_right = 1;
                    end
                    else if (current_state == DIGGING) begin
                        next_state = WALK_LEFT;
                        walk_left = 1;
                    end
                end
            end
        end

        DIGGING: begin
            digging = 1;
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
                aaah = 1;
            end
            else if (bump_left || bump_right) begin
                // No change
            end
            else if (current_state == WALK_LEFT) begin
                walk_left = 1;
            end
            else if (current_state == WALK_RIGHT) begin
                walk_right = 1;
            end
        end

        SPLATTERED: begin
            // No change
        end

    endcase
end

endmodule