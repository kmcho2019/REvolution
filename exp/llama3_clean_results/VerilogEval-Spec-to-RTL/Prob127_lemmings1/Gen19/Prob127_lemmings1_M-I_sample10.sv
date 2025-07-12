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
        state <= 1'b0; // Initialize state to LEFT
    end else begin
        if (bump_left) begin
            state <= 1'b1; // Switch to RIGHT when bumped on the left
        end else if (bump_right) begin
            state <= 1'b0; // Switch to LEFT when bumped on the right
        end
    end
end

// Use assign statements for output logic
assign walk_left = ~state; // LEFT state is represented by 0
assign walk_right = state; // RIGHT state is represented by 1

endmodule