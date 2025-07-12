module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001;  // Initialize with LSB set
        end else begin
            if (out[7] == 1'b1)
                out <= 8'b0000_0001;  // Wrap around to LSB
            else
                out <= out << 1;       // Shift left by one bit
        end
    end

endmodule