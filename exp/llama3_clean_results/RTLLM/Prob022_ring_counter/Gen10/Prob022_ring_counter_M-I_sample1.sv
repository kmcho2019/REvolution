module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to initial state (LSB set to 1)
        out <= 8'b0000_0001;
    end else begin
        // Store the MSB value in a temporary variable
        reg [7:0] temp_out;
        temp_out = out;
        
        // Shift the out register to the right
        out <= out >> 1;
        
        // Wrap the MSB around to the LSB
        out[0] <= temp_out[7];
    end
end

endmodule