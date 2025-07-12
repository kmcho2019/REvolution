module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Define the initial state of the ring counter
initial out = 8'b0000_0001;

// Synchronous reset, update state on rising edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to initial state
        out <= 8'b0000_0001;
    end else begin
        // Shift the current state one bit to the right
        // If the current state is all zeros except for the MSB (which is 1), 
        // then the next state should be all zeros except for the LSB (which is 1)
        out <= {out[6:0], out[7]};
    end
end

endmodule