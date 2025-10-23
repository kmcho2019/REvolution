module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            out <= 8'b0000_0001;  // Initialize to LSB high
        else begin
            // Shift left by one bit
            if (out[7])
                out <= 8'b0000_0001;  // Wrap around to LSB
            else
                out <= out << 1;
        end
    end

endmodule