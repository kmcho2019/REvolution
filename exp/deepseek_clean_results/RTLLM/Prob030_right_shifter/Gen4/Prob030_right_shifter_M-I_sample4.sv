module right_shifter (
    input clk,
    input d,
    input en,      // Enable signal for clock gating
    output reg [7:0] q
);

// Initialize register
initial q = 8'b0;

// Use explicit bit assignments for better timing optimization
always @(posedge clk) begin
    if (en) begin
        q[6:0] <= q[7:1];  // Right shift lower bits
        q[7] <= d;          // Insert new bit at MSB
    end
end

endmodule