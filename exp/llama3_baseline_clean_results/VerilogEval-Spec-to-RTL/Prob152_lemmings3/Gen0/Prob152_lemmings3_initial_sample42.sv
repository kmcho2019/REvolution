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
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

// Define the current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Define the direction of the Lemming (used to resume walking after falling)
reg walk_direction;

// Define the output signals
assign walk_left = (current_state == WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (current_state == WALK_RIGHT) ? 1'b1 : 1'b0;
assign aaah = (current_state == FALLING) ? 1'b1 : 1'b0;
assign digging = (current_state == DIGGING) ? 1'b1 : 1'b0;

// Define the state machine logic
always @(*)
begin
    case (current_state)
        WALK_LEFT:
        begin
            if (~ground)
                next_state = FALLING;
            else if (dig)
                next_state = DIGGING;
            else if (bump_left)
                next_state = WALK_RIGHT;
            else if (bump_right)
                next_state = WALK_LEFT;
            else
                next_state = WALK_LEFT;
        end
        WALK_RIGHT:
        begin
            if (~ground)
                next_state = FALLING;
            else if (dig)
                next_state = DIGGING;
            else if (bump_right)
                next_state = WALK_LEFT;
            else if (bump_left)
                next_state = WALK_RIGHT;
            else
                next_state = WALK_RIGHT;
        end
        FALLING:
        begin
            if (ground)
                next_state = (walk_direction) ? WALK_RIGHT : WALK_LEFT;
            else
                next_state = FALLING;
        end
        DIGGING:
        begin
            if (~ground)
                next_state = FALLING;
            else
                next_state = DIGGING;
        end
        default:
            next_state = WALK_LEFT;
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge areset)
begin
    if (areset)
    begin
        current_state <= WALK_LEFT;
        walk_direction <= 1'b0;
    end
    else
    begin
        current_state <= next_state;
        case (current_state)
            WALK_LEFT:
                walk_direction <= 1'b0;
            WALK_RIGHT:
                walk_direction <= 1'b1;
            default:
                walk_direction <= walk_direction;
        endcase
    end
end

endmodule