module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define the states
localparam WALK_LEFT = 1'b0;
localparam WALK_RIGHT = 1'b1;

// Define the current state and next state
reg state;
reg next_state;

// Define the output
assign walk_left = (state == WALK_LEFT)? 1'b1 : 1'b0;
assign walk_right = (state == WALK_RIGHT)? 1'b1 : 1'b0;

// Next state logic
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
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        if (bump_left && bump_right) begin
            state <= ~state;
        end else begin
            state <= next_state;
        end
    end
end

endmodule