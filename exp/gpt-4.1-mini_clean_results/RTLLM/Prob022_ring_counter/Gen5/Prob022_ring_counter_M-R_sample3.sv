module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize with LSB set
    end else begin
        if (out[7] == 1'b1) begin
            // MSB is 1, wrap around by shifting left and setting LSB
            out <= (out << 1) | 8'b0000_0001;
        end else begin
            // Shift left by 1, MSB is zero, so just shift
            out <= out << 1;
        end
    end
end

endmodule