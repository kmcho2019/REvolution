module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding:
    // bit[1]: 0=WALK, 1=FALL
    // bit[0]: 0=left, 1=right (only valid in WALK state)
    reg [1:0] state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // WALK left
        end
        else begin
            if (state[1]) begin  // FALL state
                if (ground) begin
                    state[1] <= 1'b0;  // Return to WALK
                end
            end
            else begin  // WALK state
                if (!ground) begin
                    state[1] <= 1'b1;  // Start FALL
                end
                else if ((state[0] & bump_right) | (!state[0] & bump_left)) begin
                    state[0] <= ~state[0];  // Toggle direction
                end
            end
        end
    end

    // Output logic
    assign walk_left = (~state[1]) & (~state[0]);
    assign walk_right = (~state[1]) & state[0];
    assign aaah = state[1];

endmodule