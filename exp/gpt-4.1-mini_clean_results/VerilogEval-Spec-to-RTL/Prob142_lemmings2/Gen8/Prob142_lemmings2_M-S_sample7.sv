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
    // bit 1 = falling (1 = falling)
    // bit 0 = direction (0 = left, 1 = right)
    reg [1:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold

        if (state[1]) begin
            // Falling state
            if (ground)
                next_state[1] = 1'b0; // stop falling, keep direction
            // direction unchanged while falling
        end else begin
            // Walking state
            if (!ground)
                next_state[1] = 1'b1; // start falling
            else begin
                // update direction only when walking and on ground
                if (bump_left && bump_right)
                    next_state[0] = ~state[0]; // flip direction
                else if (bump_left)
                    next_state[0] = 1'b1; // walk right
                else if (bump_right)
                    next_state[0] = 1'b0; // walk left
                // else keep direction
            end
        end
    end

    // Sequential with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walking left, not falling
        else
            state <= next_state;
    end

    // Moore outputs
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];

endmodule