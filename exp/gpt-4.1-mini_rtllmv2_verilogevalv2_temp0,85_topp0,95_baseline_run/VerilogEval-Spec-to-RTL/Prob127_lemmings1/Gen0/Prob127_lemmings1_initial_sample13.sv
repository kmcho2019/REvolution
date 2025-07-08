module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    output reg  walk_left,
    output reg  walk_right
);

// State encoding
localparam WALK_LEFT  = 1'b0;
localparam WALK_RIGHT = 1'b1;

reg state, next_state;

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case(state)
        WALK_LEFT: begin
            if (bump_left || bump_right)
                next_state = WALK_RIGHT;
            else
                next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (bump_left || bump_right)
                next_state = WALK_LEFT;
            else
                next_state = WALK_RIGHT;
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Output logic (Moore outputs depend only on state)
always @(*) begin
    walk_left  = (state == WALK_LEFT);
    walk_right = (state == WALK_RIGHT);
end

endmodule