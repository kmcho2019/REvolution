module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [0:0] state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize to LEFT state
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        if (bump_left || bump_right) begin
            state <= ~state; // Switch direction
        end
        walk_left <= ~state;
        walk_right <= state;
    end
end

endmodule