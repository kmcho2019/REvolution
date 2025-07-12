module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define the states
parameter WALK_LEFT = 1'b0;
parameter WALK_RIGHT = 1'b1;

// Declare the state register
reg state;
reg next_state;

// Assign the outputs based on the current state
assign walk_left = ~state;
assign walk_right = state;

// Define the next state logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        default: next_state = WALK_LEFT;
    endcase

    // If both bump_left and bump_right are high, switch directions
    if (bump_left && bump_right) begin
        next_state = ~state;
    end
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule