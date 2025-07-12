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
        state <= 1'b0; // Initialize state to walk left (0)
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        if (state == 1'b0) begin // Currently walking left
            if (bump_left) begin
                state <= 1'b1; // Switch to walking right
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end else begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
        end else begin // Currently walking right
            if (bump_right) begin
                state <= 1'b0; // Switch to walking left
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end else begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
        end
    end
end

endmodule