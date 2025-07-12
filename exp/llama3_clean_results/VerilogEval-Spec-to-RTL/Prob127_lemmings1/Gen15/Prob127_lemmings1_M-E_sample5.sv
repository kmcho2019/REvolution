module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

reg direction; // 1-bit register to store the current direction

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 0; // Initialize direction to left (0)
    end else if (bump_left || bump_right) begin
        direction <= ~direction; // Toggle direction on bump
    end
end

// Use assign statements for output logic
assign walk_left = ~direction;
assign walk_right = direction;

endmodule