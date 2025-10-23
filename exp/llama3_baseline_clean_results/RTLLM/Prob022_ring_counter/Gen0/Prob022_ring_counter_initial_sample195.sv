module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the counter to its starting state
        out <= 8'b0000_0001;
    end else begin
        // Shift the high bit to the next position, wrapping around to the start after the last bit
        for (i = 0; i < 8; i++) begin
            if (out[i] == 1'b1) begin
                if (i == 7) begin
                    // Wrap around to the LSB
                    out <= 8'b0000_0001;
                end else begin
                    // Shift the high bit to the next position
                    out <= (1 << (i + 1));
                end
            end
        end
    end
end

endmodule