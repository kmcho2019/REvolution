module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset to the initial state
    end else begin
        out <= next_state; // Update the current state
    end
end

always @(*) begin
    if (out[7]) begin // If the MSB is 1, wrap around
        next_state = 8'b0000_0001;
    end else begin // Otherwise, shift the bits to the left
        next_state = out << 1;
    end
end

endmodule