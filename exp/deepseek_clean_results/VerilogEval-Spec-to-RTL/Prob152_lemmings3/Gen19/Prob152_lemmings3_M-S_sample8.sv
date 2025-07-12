module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding:
    // [1] - 1=FALL, 0=WALK
    // [0] - direction (0=left, 1=right)
    reg [1:0] state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // WALK left
        end else begin
            if (state[1]) begin // FALL
                if (ground) state[1] <= 1'b0; // Return to WALK
            end else begin // WALK
                if (~ground) begin
                    state[1] <= 1'b1; // Start FALL
                end else if (dig) begin
                    // Stay in WALK state but set digging output
                end else begin
                    // Handle bumps - priority to right if both
                    if (bump_right) state[0] <= 1'b0;
                    else if (bump_left) state[0] <= 1'b1;
                end
            end
        end
    end

    // Output logic
    assign walk_left = (~state[1]) & (~state[0]) & (~dig);
    assign walk_right = (~state[1]) & state[0] & (~dig);
    assign aaah = state[1];
    assign digging = (~state[1]) & dig & ground;

endmodule