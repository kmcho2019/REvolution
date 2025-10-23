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

    // State encoding: [1]=falling, [0]=direction (0=left, 1=right)
    reg [1:0] state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // Walking left
        end
        else if (state[1]) begin
            // Falling state
            if (ground) state[1] <= 1'b0;  // Stop falling
        end
        else begin
            // Walking state
            if (!ground) begin
                state[1] <= 1'b1;  // Start falling
            end
            else if ((state[0] && bump_right) || (!state[0] && bump_left)) begin
                state[0] <= !state[0];  // Change direction
            end
        end
    end

    // Output assignments
    assign walk_left = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];
    assign aaah = state[1];

endmodule