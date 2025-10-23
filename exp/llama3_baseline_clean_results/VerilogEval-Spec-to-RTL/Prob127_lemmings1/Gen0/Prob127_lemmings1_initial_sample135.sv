module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define the states
localparam WALK_LEFT = 1'b0;
localparam WALK_RIGHT = 1'b1;

// Define the state variable
reg current_state;
reg next_state;

// Determine the next state
always @(*) begin
    case(current_state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        if (bump_left && bump_right) begin
            if (current_state == WALK_LEFT) begin
                current_state <= WALK_RIGHT;
            end else begin
                current_state <= WALK_LEFT;
            end
        end else begin
            current_state <= next_state;
        end
    end
end

// Assign the outputs based on the current state
assign walk_left = (current_state == WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (current_state == WALK_RIGHT) ? 1'b1 : 1'b0;

endmodule