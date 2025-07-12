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

    always @(*) begin
        next_state = state;  // default: hold current state

        if (state[1] == 1'b0) begin
            // walking
            if (ground == 1'b0) begin
                // start falling, keep direction
                next_state = {1'b1, state[0]};
            end else begin
                // on ground and walking: bumps may change direction
                if (bump_left && bump_right) begin
                    // bumps on both sides: flip direction
                    next_state = {1'b0, ~state[0]};
                end else if (bump_left) begin
                    // bump left -> walk right
                    next_state = {1'b0, 1'b1};
                end else if (bump_right) begin
                    // bump right -> walk left
                    next_state = {1'b0, 1'b0};
                end else begin
                    // no change in direction
                    next_state = state;
                end
            end
        end else begin
            // falling
            if (ground == 1'b1) begin
                // ground reappeared, resume walking same direction
                next_state = {1'b0, state[0]};
            end else begin
                // still falling, keep direction
                next_state = state;
            end
        end
    end

    // Asynchronous reset, synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walk_left on reset
        else
            state <= next_state;
    end

    // Moore outputs based on state
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];

endmodule