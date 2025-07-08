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

// State encoding
localparam WALK_LEFT  = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING    = 2'b10;

reg [1:0] state, next_state;
reg prev_walk_dir; // 0 = left, 1 = right; stores walking direction before falling

// Asynchronous reset and state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_walk_dir <= 1'b0; // left direction on reset
    end else begin
        state <= next_state;
        // Update prev_walk_dir only when not falling
        if (next_state == WALK_LEFT)
            prev_walk_dir <= 1'b0;
        else if (next_state == WALK_RIGHT)
            prev_walk_dir <= 1'b1;
    end
end

// Next state logic
always @(*) begin
    case(state)
        WALK_LEFT: begin
            if (!ground)
                next_state = FALLING;
            else if (bump_left || bump_right)
                next_state = WALK_RIGHT;
            else
                next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (!ground)
                next_state = FALLING;
            else if (bump_left || bump_right)
                next_state = WALK_LEFT;
            else
                next_state = WALK_RIGHT;
        end
        FALLING: begin
            if (ground) begin
                // Restore to previous walking direction
                if (prev_walk_dir == 1'b0)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end else begin
                next_state = FALLING;
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Output logic: Moore outputs depend only on current state
assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah       = (state == FALLING);

endmodule