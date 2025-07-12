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
    // bit1: falling (1) or walking (0)
    // bit0: direction (0=left, 1=right)
    reg [1:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default to hold current state

        if (state[1] == 1'b0) begin
            // Currently walking
            if (ground == 1'b0) begin
                // Start falling, preserve direction
                next_state = {1'b1, state[0]};
            end else begin
                // On ground and walking: check bumps
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    next_state = {1'b0, ~state[0]};
                end else if (bump_left) begin
                    // Bumped left: walk right
                    next_state = {1'b0, 1'b1};
                end else if (bump_right) begin
                    // Bumped right: walk left
                    next_state = {1'b0, 1'b0};
                end else begin
                    // No bumps, keep same state
                    next_state = state;
                end
            end
        end else begin
            // Currently falling
            if (ground == 1'b1) begin
                // Ground reappeared: stop falling, keep direction
                next_state = {1'b0, state[0]};
            end else begin
                // Still falling, hold state
                next_state = state;
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00; // walking left on reset
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs from state bits
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule