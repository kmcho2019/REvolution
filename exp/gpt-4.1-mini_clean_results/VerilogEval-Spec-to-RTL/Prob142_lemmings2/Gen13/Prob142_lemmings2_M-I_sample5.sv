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

    // State encoding:
    // bit1: falling (1) / walking (0)
    // bit0: direction: 0=left, 1=right
    // 00 = walk_left
    // 01 = walk_right
    // 10 = fall_left
    // 11 = fall_right

    reg [1:0] state, next_state;

    wire bump_any = bump_left | bump_right;

    always @(*) begin
        next_state = state;  // default: hold current state

        if (state[1]) begin
            // falling
            if (ground)
                next_state = {1'b0, state[0]};  // back to walking, same direction
            else
                next_state = state;  // keep falling
        end else begin
            // walking
            if (!ground)
                next_state = {1'b1, state[0]};  // start falling, keep direction
            else if (bump_any)
                next_state = {1'b0, ~state[0]}; // flip direction
            else
                next_state = state; // no change
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walk_left on reset
        else
            state <= next_state;
    end

    // Moore outputs
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];

endmodule