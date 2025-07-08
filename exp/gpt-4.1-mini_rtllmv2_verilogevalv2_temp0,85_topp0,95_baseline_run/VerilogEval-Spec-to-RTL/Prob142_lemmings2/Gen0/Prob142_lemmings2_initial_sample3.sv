module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// State encoding
localparam WALK_LEFT  = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING    = 2'b10;

reg [1:0] state, next_state;
// To store walking direction before falling, to resume after falling
reg saved_walk_left;

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        saved_walk_left <= 1'b1; // walking left at reset
    end else begin
        state <= next_state;
        // Update saved_walk_left only when on ground walking states
        if (ground && (state == WALK_LEFT || state == WALK_RIGHT)) begin
            saved_walk_left <= (next_state == WALK_LEFT);
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (!ground)
                next_state = FALLING;
            else if (bump_left || bump_right) // bump_left or bump_right or both -> switch direction
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
                // resume walking in saved direction
                next_state = saved_walk_left ? WALK_LEFT : WALK_RIGHT;
            end else
                next_state = FALLING;
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Output logic (Moore)
always @(*) begin
    walk_left  = 1'b0;
    walk_right = 1'b0;
    aaah       = 1'b0;

    case (state)
        WALK_LEFT:  walk_left  = 1'b1;
        WALK_RIGHT: walk_right = 1'b1;
        FALLING:    aaah       = 1'b1;
    endcase
end

endmodule