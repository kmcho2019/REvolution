module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
                else if (bump_left || bump_right) begin
                    if (bump_left && bump_right)
                        next_state = WALK_RIGHT;
                    else if (bump_left)
                        next_state = WALK_RIGHT;
                    else // bump_right
                        next_state = WALK_RIGHT; // bump_right while walking left means switch to walk right?
                end else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
                else if (bump_left || bump_right) begin
                    if (bump_left && bump_right)
                        next_state = WALK_LEFT;
                    else if (bump_right)
                        next_state = WALK_LEFT;
                    else // bump_left
                        next_state = WALK_LEFT; // bump_left while walking right means switch to walk left?
                end else
                    next_state = WALK_RIGHT;
            end
            FALL_LEFT: begin
                if (ground)
                    next_state = WALK_LEFT;
                else
                    next_state = FALL_LEFT;
            end
            FALL_RIGHT: begin
                if (ground)
                    next_state = WALK_RIGHT;
                else
                    next_state = FALL_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output logic (Moore)
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule