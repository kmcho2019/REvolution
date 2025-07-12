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
    reg is_digging;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // WALK left
            is_digging <= 1'b0;
        end else begin
            if (state[1]) begin // FALL
                if (ground) state[1] <= 1'b0; // Return to WALK
            end else begin // WALK
                if (~ground) begin
                    state[1] <= 1'b1; // FALL
                    is_digging <= 1'b0;
                end else if (dig) begin
                    is_digging <= 1'b1;
                end else if (~is_digging) begin
                    // Handle bumps - priority to right if both
                    if (bump_right) state[0] <= 1'b0;
                    if (bump_left) state[0] <= 1'b1;
                end
            end
        end
    end

    // Output logic
    assign walk_left = ~state[1] & ~state[0] & ~is_digging;
    assign walk_right = ~state[1] & state[0] & ~is_digging;
    assign aaah = state[1];
    assign digging = ~state[1] & is_digging;

endmodule