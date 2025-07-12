module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

reg state; // Using a 1-bit state variable

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize state to LEFT (0)
    end else begin
        state <= (bump_left && ~state) || (bump_right && state);
    end
end

// Use assign statements for output logic
assign walk_left = ~state;
assign walk_right = state;

endmodule