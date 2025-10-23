module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

reg state; // Using a 1-bit state variable

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize state to walking left
    end else begin
        if (bump_left) begin
            state <= 1; // Walk right if bumped on the left
        end else if (bump_right) begin
            state <= 0; // Walk left if bumped on the right
        end
    end
end

assign walk_left = ~state;
assign walk_right = state;

endmodule