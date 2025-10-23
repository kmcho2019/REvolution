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

    // Registered inputs to reduce glitches and combinational toggling
    reg bump_left_r, bump_right_r, ground_r;

    always @(posedge clk) begin
        bump_left_r  <= bump_left;
        bump_right_r <= bump_right;
        ground_r     <= ground;
    end

    // Combinational logic for next state using conditional operators
    always @(*) begin
        if (state[1] == 1'b0) begin
            // walking states
            if (ground_r == 1'b0) begin
                // start falling, preserve direction bit0
                next_state = {1'b1, state[0]};
            end else begin
                // on ground and walking: bumps determine direction change
                if (bump_left_r || bump_right_r) begin
                    // bump on either side (or both) flips direction accordingly
                    // bump_left -> walk right (bit0=1)
                    // bump_right -> walk left (bit0=0)
                    // bump on both sides -> flip direction
                    if (bump_left_r && bump_right_r)
                        next_state = {1'b0, ~state[0]};
                    else if (bump_left_r)
                        next_state = {1'b0, 1'b1};
                    else // bump_right_r only
                        next_state = {1'b0, 1'b0};
                end else begin
                    next_state = state;
                end
            end
        end else begin
            // falling states
            if (ground_r == 1'b1) begin
                // ground returned, stop falling, keep direction bit0
                next_state = {1'b0, state[0]};
            end else begin
                next_state = state;
            end
        end
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (areset) begin
            state <= 2'b00; // walking left on reset
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs derived from state
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];

endmodule