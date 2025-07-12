module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize with LSB set
    end
    else begin
        // Circular shift left using concatenation
        // Takes bits 6:0 and shifts left, with bit 7 wrapping around
        out <= {out[6:0], out[7]};
    end
end

endmodule