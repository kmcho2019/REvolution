module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
parameter STATE_WALK_LEFT = 2'b00;
parameter STATE_WALK_RIGHT = 2'b01;
parameter STATE_FALLING = 2'b10;

// State variable
reg [1:0] state;

// Previous walking direction when falling
reg prev_direction;

// Output signals
assign walk_left = (state == STATE_WALK_LEFT)? 1'b1 : 1'b0;
assign walk_right = (state == STATE_WALK_RIGHT)? 1'b1 : 1'b0;
assign aaah = (state == STATE_FALLING)? 1'b1 : 1'b0;

// State machine logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset the state machine to walking left
        state <= STATE_WALK_LEFT;
        prev_direction <= 1'b0;
    end else begin
        case (state)
            STATE_WALK_LEFT: begin
                if (!ground) begin
                    // Lemming is falling, save the previous walking direction
                    prev_direction <= 1'b0;
                    state <= STATE_FALLING;
                end else if (bump_left) begin
                    // Lemming is bumped on the left, switch to walking right
                    state <= STATE_WALK_RIGHT;
                end else if (bump_right) begin
                    // This condition should not be reached because the Lemming is walking left
                end
            end
            STATE_WALK_RIGHT: begin
                if (!ground) begin
                    // Lemming is falling, save the previous walking direction
                    prev_direction <= 1'b1;
                    state <= STATE_FALLING;
                end else if (bump_left) begin
                    // This condition should not be reached because the Lemming is walking right
                end else if (bump_right) begin
                    // Lemming is bumped on the right, switch to walking left
                    state <= STATE_WALK_LEFT;
                end
            end
            STATE_FALLING: begin
                if (ground) begin
                    // Ground reappeared, resume walking in the same direction as before the fall
                    if (prev_direction) begin
                        state <= STATE_WALK_RIGHT;
                    end else begin
                        state <= STATE_WALK_LEFT;
                    end
                end
            end
        endcase
    end
end

endmodule