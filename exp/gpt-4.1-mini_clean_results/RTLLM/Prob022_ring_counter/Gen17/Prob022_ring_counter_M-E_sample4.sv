module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001;  // Initialize with LSB set
        end else begin
            if (out[7]) begin
                // If MSB is set, wrap around to LSB
                out <= 8'b0000_0001;
            end else begin
                // Shift left by one bit
                out <= out << 1;
            end
        end
    end

endmodule