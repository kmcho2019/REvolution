module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize to starting state when reset is high
    end else begin
        // Calculate the next state based on the current state
        if (out == 8'b1000_0000) begin
            out <= 8'b0000_0001; // Wrap around to the LSB
        end else begin
            out <= out << 1; // Shift the 1 to the next bit
        end
    end
end

endmodule