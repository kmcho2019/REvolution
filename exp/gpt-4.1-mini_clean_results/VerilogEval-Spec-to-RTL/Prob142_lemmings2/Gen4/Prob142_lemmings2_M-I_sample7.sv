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
    // bit 1: falling (1) or walking (0)
    // bit 0: direction (0=left, 1=right)
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00; // walking left
        end else begin
            if (state[1]) begin
                // falling
                if (ground)
                    state[1] <= 1'b0; // stop falling, keep direction
                // else remain falling
                // direction bit unchanged
            end else begin
                // walking
                if (!ground) begin
                    // start falling, preserve direction
                    state[1] <= 1'b1;
                end else begin
                    // on ground and walking: update direction per bumps
                    if (bump_left && bump_right) begin
                        // flip direction bit (LSB)
                        state[0] <= ~state[0];
                    end else if (bump_left) begin
                        state[0] <= 1'b1; // walk right
                    end else if (bump_right) begin
                        state[0] <= 1'b0; // walk left
                    end
                    // else direction unchanged
                end
            end
        end
    end

    // Moore outputs
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];

endmodule