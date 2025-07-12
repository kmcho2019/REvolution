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
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;

// Define the current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Define the direction
reg direction;

// Define the previous direction
reg prev_direction;

// Assign the outputs based on the current state
always @(*) begin
    case(current_state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        WALK_RIGHT: begin
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

// Determine the next state
always @(*) begin
    case(current_state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (prev_direction) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
    endcase
end

// Update the current state and direction
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
        prev_direction <= 1'b1;
    end else begin
        if (current_state == WALK_LEFT) begin
            prev_direction <= 1'b1;
        end else if (current_state == WALK_RIGHT) begin
            prev_direction <= 1'b0;
        end
        current_state <= next_state;
    end
end

endmodule