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

// Modes
localparam MODE_WALK   = 2'b00;
localparam MODE_FALL   = 2'b01;
localparam MODE_DIG    = 2'b10;

reg [1:0] mode, next_mode;
reg       direction, next_direction; // 0=left, 1=right

reg prev_ground;

// Update registers: asynchronous reset for mode and direction
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        direction <= 1'b0;  // walk left on reset
        prev_ground <= 1'b1; // assume on ground at start
    end else begin
        mode <= next_mode;
        direction <= next_direction;
        prev_ground <= ground;
    end
end

wire stable_ground = (ground == 1'b1) && (prev_ground == 1'b1);

always @(*) begin
    // Default: hold current mode and direction
    next_mode = mode;
    next_direction = direction;

    case (mode)
        MODE_WALK: begin
            // Priority fall > dig > bump

            if (ground == 1'b0) begin
                // fall immediately
                next_mode = MODE_FALL;
                // direction unchanged
            end else if (dig == 1'b1 && stable_ground) begin
                // start digging
                next_mode = MODE_DIG;
                // direction unchanged
            end else if (stable_ground && (bump_left || bump_right)) begin
                // bump logic
                if (bump_left && bump_right) begin
                    // toggle direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    // bumped left => walk right
                    next_direction = 1'b1;
                end else begin // bump_right only
                    next_direction = 1'b0;
                end
            end
            // else keep walking and direction
        end

        MODE_FALL: begin
            // stay falling until ground reappears
            if (ground == 1'b1) begin
                next_mode = MODE_WALK;
                // keep direction same as before falling
            end
        end

        MODE_DIG: begin
            // keep digging while on ground, else fall
            if (ground == 1'b0) begin
                next_mode = MODE_FALL;
                // direction unchanged
            end
            // else stay digging
        end

        default: begin
            // Should never occur, reset to walking left
            next_mode = MODE_WALK;
            next_direction = 1'b0;
        end
    endcase
end

// Output assignments (Moore outputs)
assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule