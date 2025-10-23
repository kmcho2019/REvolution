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
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

// State register
reg [1:0] state, next_state;

// Initialize the state register
initial state = WALK_LEFT;
always @(posedge clk or posedge areset)
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;

// Combinational logic for next state and outputs
always @(*)
begin
    case (state)
        WALK_LEFT:
        begin
            if (!ground)
                next_state = FALLING;
            else if (dig)
                next_state = DIGGING;
            else if (bump_left)
                next_state = WALK_RIGHT;
            else if (bump_right)
                next_state = WALK_LEFT;
            else
                next_state = WALK_LEFT;
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALK_RIGHT:
        begin
            if (!ground)
                next_state = FALLING;
            else if (dig)
                next_state = DIGGING;
            else if (bump_right)
                next_state = WALK_LEFT;
            else if (bump_left)
                next_state = WALK_RIGHT;
            else
                next_state = WALK_RIGHT;
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING:
        begin
            if (ground)
            begin
                if (next_state == DIGGING)
                    next_state = WALK_LEFT;
                else if (next_state == WALK_RIGHT)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            else
                next_state = FALLING;
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING:
        begin
            if (!ground)
                next_state = FALLING;
            else
                next_state = DIGGING;
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default:
        begin
            next_state = WALK_LEFT;
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule