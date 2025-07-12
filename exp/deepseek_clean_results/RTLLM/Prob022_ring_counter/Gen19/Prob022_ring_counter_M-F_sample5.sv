module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'd1;          // Initialize with LSB set (00000001)
    end else begin
        if (out == 8'd128) begin  // Check for MSB set (10000000)
            out <= 8'd1;      // Wrap around to LSB
        end else begin
            out <= out << 1;  // Normal left shift operation
        end
    end
end

endmodule