module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // Initialize to LEFT state
    end else begin
        if (bump_left || bump_right) begin
            state <= ~state; // Switch direction
        end
    end
end

// Define combinational logic
always_comb begin
    if (state) begin
        walk_left = 1'b0;
        walk_right = 1'b1; // RIGHT state
    end else begin
        walk_left = 1'b1;
        walk_right = 1'b0; // LEFT state
    end
end

endmodule