module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Define the lookup table for next states
reg [3:0] lut[15:0];

// Initialize the LUT with next states
initial begin
    for (int i = 0; i < 16; i++) begin
        if (i == 15) begin
            // Wrap around from 15 to 0
            lut[i] = 4'd0;
        end else begin
            lut[i] = i + 1'd1;
        end
    end
end

// Use the LUT to update the counter state
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        q <= 4'd0;
    end else begin
        // Use the current state as an index into the LUT
        q <= lut[q];
    end
end

endmodule