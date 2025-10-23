module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
parameter IDLE_LEFT = 2'b00;
parameter IDLE_RIGHT = 2'b01;
parameter FALLING = 2'b10;

// Declare the current state and next state
reg [1:0] state;
reg [1:0] next_state;

// Declare the current direction
reg direction;

// Assign the outputs based on the current state
always @(*) begin
    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

// Determine the next state based on the current state and inputs
always @(*) begin
    case (state)
        IDLE_LEFT: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
                direction = 1'b0; // left
            end else if (bump_left == 1'b1) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right == 1'b1) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
                direction = 1'b1; // right
            end else if (bump_left == 1'b1) begin
                next_state = IDLE_LEFT;
            end else if (bump_right == 1'b1) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground == 1'b1) begin
                if (direction == 1'b0) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state = IDLE_LEFT;
    end else begin
        state = next_state;
    end
end

endmodule