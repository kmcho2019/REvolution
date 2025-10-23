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

    // State bits: [1] = falling, [0] = direction (0=left,1=right)
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00; // walking left, not falling
        end else begin
            // falling bit update
            if (state[1]) begin
                // currently falling
                if (ground)
                    state[1] <= 1'b0; // landed
                // else remain falling
            end else begin
                // currently walking
                if (!ground)
                    state[1] <= 1'b1; // start falling
                else if (bump_left || bump_right)
                    state[0] <= ~state[0]; // flip direction on any bump
                // else keep direction
            end
        end
    end

    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];

endmodule