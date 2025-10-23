module ring_counter(
    input  wire clk,
    input  wire reset,
    output reg [7:0] out
);

// 3-bit position register to keep track of the current bit in the output
reg [2:0] pos;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset position to 0 and output to initial state (LSB set to 1)
        pos <= 3'd0;
        out <= 8'b0000_0001;
    end else begin
        // Increment position and wrap around to 0 after 7
        pos <= pos + 1;
        if (pos == 3'd8) begin
            pos <= 3'd0;
        end
        
        // Update output by setting the bit at the current position
        out <= 1 << pos;
    end
end

endmodule