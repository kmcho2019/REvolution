module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

reg state; // Using a 1-bit state variable

// Use a single always block for sequential logic and output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize state to LEFT (0)
        walk_left <= 1'b1; // Initialize walk_left to 1
        walk_right <= 1'b0; // Initialize walk_right to 0
    end else begin
        if (bump_left && !bump_right) begin
            state <= 1; // Switch to RIGHT (1)
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end else if (bump_right && !bump_left) begin
            state <= 0; // Switch to LEFT (0)
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end else if (bump_left && bump_right) begin
            state <= ~state; // Switch direction
            walk_left <= ~walk_left;
            walk_right <= ~walk_right;
        end
    end
end

endmodule