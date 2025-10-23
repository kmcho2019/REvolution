module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] next_out;

// Combinational next state logic
always @(*) begin
    if (out == 8'b1000_0000) begin
        next_out = 8'b0000_0001;  // Wrap around from MSB to LSB
    end else begin
        next_out = out << 1;      // Shift left by 1 otherwise
    end
end

// Sequential state registration
always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001;      // Initialize on reset
    end else begin
        out <= next_out;          // Update state
    end
end

endmodule