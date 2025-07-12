module TopModule (
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

// Direction encoding
localparam LEFT  = 1'b0;
localparam RIGHT = 1'b1;

// Mode encoding
localparam MODE_WALK = 2'b00;
localparam MODE_FALL = 2'b01;
localparam MODE_DIG  = 2'b10;

// Registers for state
reg direction; // LEFT or RIGHT
reg [1:0] mode; // walking, falling, digging

// Next-state signals
reg next_direction;
reg [1:0] next_mode;

always @(*) begin
    // Default assignments
    next_direction = direction;
    next_mode = mode;

    case (mode)
        MODE_WALK: begin
            // Priority: fall > dig > bump
            if (!ground) begin
                next_mode = MODE_FALL;      // fall when ground lost
            end else if (dig) begin
                next_mode = MODE_DIG;       // start digging if dig=1 and grounded
            end else if (bump_left || bump_right) begin
                // switch direction on any bump while walking
                // if both bump, flip direction
                if (bump_left && bump_right)
                    next_direction = ~direction;
                else if (bump_left)
                    next_direction = RIGHT;
                else // bump_right only
                    next_direction = LEFT;
                next_mode = MODE_WALK;       // stay walking
            end else begin
                // continue walking same direction
                next_mode = MODE_WALK;
                next_direction = direction;
            end
        end

        MODE_FALL: begin
            // Falling: transition to walking if ground reappears
            if (ground)
                next_mode = MODE_WALK;
            else
                next_mode = MODE_FALL;
            // direction unchanged during fall
            next_direction = direction;
        end

        MODE_DIG: begin
            // Digging: switch to fall if ground lost, else keep digging
            if (!ground)
                next_mode = MODE_FALL;
            else
                next_mode = MODE_DIG;
            // direction unchanged while digging
            next_direction = direction;
        end

        default: begin
            // default safe state
            next_direction = LEFT;
            next_mode = MODE_WALK;
        end
    endcase
end

// Sequential logic with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= LEFT;
        mode <= MODE_WALK;
    end else begin
        direction <= next_direction;
        mode <= next_mode;
    end
end

// Output logic (Moore)
assign walk_left  = (mode == MODE_WALK) && (direction == LEFT);
assign walk_right = (mode == MODE_WALK) && (direction == RIGHT);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule