module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Edge detection registers
    reg bump_left_prev, bump_right_prev;
    wire bump_left_edge = bump_left & ~bump_left_prev;
    wire bump_right_edge = bump_right & ~bump_right_prev;

    // Toggle bit for direction (0=left, 1=right)
    reg direction;

    // Edge detection logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bump_left_prev <= 1'b0;
            bump_right_prev <= 1'b0;
        end else begin
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
        end
    end

    // Direction toggle logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // Start walking left
        end else if (bump_left_edge || bump_right_edge) begin
            direction <= ~direction;  // Toggle direction on any bump edge
        end
    end

    // Output assignments
    assign walk_left = ~direction;
    assign walk_right = direction;

endmodule