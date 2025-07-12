module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg walk_left_r, walk_right_r;

    // Asynchronous positive-edge reset sets walk_left active
    // On clock edge, toggle states if bump_left or bump_right is 1
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_r  <= 1'b1;
            walk_right_r <= 1'b0;
        end else if (bump_left | bump_right) begin
            // Toggle states
            walk_left_r  <= ~walk_left_r;
            walk_right_r <= ~walk_right_r;
        end
        // else hold current states
    end

    // Outputs directly reflect the one-hot states (Moore outputs)
    assign walk_left  = walk_left_r;
    assign walk_right = walk_right_r;

endmodule