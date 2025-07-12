module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize with LSB high
    end else begin
        // Shift left with wrap-around using bit operations
        out <= (out << 1) | (out >> 7);
    end
end

endmodule