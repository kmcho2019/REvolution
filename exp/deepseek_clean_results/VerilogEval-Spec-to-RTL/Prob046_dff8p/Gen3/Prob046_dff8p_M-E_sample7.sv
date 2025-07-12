module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// 16-bit shift register containing two copies of the reset pattern
reg [15:0] reset_pattern = 16'b0011010000110100;

always @(negedge clk) begin
    if (reset) begin
        // Select the appropriate 8-bit window from the shift register
        q <= reset_pattern[7:0];
        // Rotate the pattern for potential future use
        reset_pattern <= {reset_pattern[0], reset_pattern[15:1]};
    end else begin
        q <= d;
        // Maintain the reset pattern even during normal operation
        reset_pattern <= {reset_pattern[0], reset_pattern[15:1]};
    end
end

endmodule