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

    // Synchronized bump signals to avoid glitches
    reg bump_left_sync, bump_right_sync;

    always @(posedge clk) begin
        bump_left_sync  <= bump_left;
        bump_right_sync <= bump_right;
    end

    // Combinational logic for next state
    always @(*) begin
        if (state[1] == 1'b0) begin
            // walking states
            if (ground == 1'b0) begin
                // start falling, preserve direction bit0
                next_state = {1'b1, state[0]};
            end else begin
                // on ground and walking: bumps determine direction change
                if (bump_left_sync && bump_right_sync) begin
                    // flip direction bit
                    next_state = {1'b0, ~state[0]};
                end else if (bump_left_sync) begin
                    // bump left -> walk right (bit0=1)
                    next_state = {1'b0, 1'b1};
                end else if (bump_right_sync) begin
                    // bump right -> walk left (bit0=0)
                    next_state = {1'b0, 1'b0};
                end else begin
                    // no change, keep walking same direction
                    next_state = state;
                end
            end
        end else begin
            // falling states
            if (ground == 1'b1) begin
                // ground returned, stop falling, keep direction bit0
                next_state = {1'b0, state[0]};
            end else begin
                // keep falling, direction unchanged
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