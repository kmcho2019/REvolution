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

    // State: bit1 = falling, bit0 = direction (0=left,1=right)
    reg [1:0] state, next_state;

    always @(*) begin
        next_state = state;

        if (state[1] == 1'b0) begin
            // Walking
            if (ground == 1'b0) begin
                // Start falling, keep direction
                next_state = {1'b1, state[0]};
            end else if (bump_left || bump_right) begin
                // Flip direction when bumped on any side while walking
                next_state = {1'b0, ~state[0]};
            end
            // else no change
        end else begin
            // Falling
            if (ground == 1'b1) begin
                // Stop falling, keep direction
                next_state = {1'b0, state[0]};
            end
            // else remain falling
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walking left
        else
            state <= next_state;
    end

    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule