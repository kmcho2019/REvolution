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

reg [1:0] state, next_state;
reg walk_left_reg, walk_right_reg, aaah_reg;

// Define the states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;

// Define the outputs for each state
always @(*)
begin
    case (state)
        WALK_LEFT: begin
            walk_left_reg = 1'b1;
            walk_right_reg = 1'b0;
            aaah_reg = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b1;
            aaah_reg = 1'b0;
        end
        FALLING: begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b0;
            aaah_reg = 1'b1;
        end
        default: begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b0;
            aaah_reg = 1'b0;
        end
    endcase
end

// Define the next state logic
always @(*)
begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (bump_left || (bump_left && bump_right))
                next_state = WALK_RIGHT;
            else if (!ground)
                next_state = FALLING;
        end
        WALK_RIGHT: begin
            if (bump_right || (bump_left && bump_right))
                next_state = WALK_LEFT;
            else if (!ground)
                next_state = FALLING;
        end
        FALLING: begin
            if (ground)
                next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk or posedge areset)
begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;
assign aaah = aaah_reg;

endmodule