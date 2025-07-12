module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // 1-bit state variable

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state 0 (walking left)
        state <= 1'b0;
    end else begin
        // Next state logic
        if (bump_left) begin
            state <= 1'b1; // Walk right
        end else if (bump_right) begin
            state <= 1'b0; // Walk left
        end else if (bump_left && bump_right) begin
            // If both bump_left and bump_right are 1, switch direction
            state <= ~state;
        end
    end
end

// Output logic
always @(*) begin
    if (state == 1'b0) begin
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        walk_left <= 1'b0;
        walk_right <= 1'b1;
    end
end

endmodule