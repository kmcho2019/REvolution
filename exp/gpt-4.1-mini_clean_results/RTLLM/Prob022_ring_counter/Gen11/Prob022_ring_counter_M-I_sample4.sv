module ring_counter (
    input  clk,
    input  reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001; // Initialize with LSB high
        end else begin
            if (out[7] == 1'b1) begin
                // MSB is set, wrap around to LSB
                out <= 8'b0000_0001;
            end else begin
                // Shift left by one
                out <= out << 1;
            end
        end
    end

endmodule