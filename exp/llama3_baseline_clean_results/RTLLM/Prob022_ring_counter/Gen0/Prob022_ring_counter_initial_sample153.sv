module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

    // Initialize the output to its starting state when reset is high
    always @(posedge reset) begin
        out <= 8'b0000_0001;  // Set the LSB to 1
    end

    // Update the state on each rising edge of the clock signal
    always @(posedge clk) begin
        if (~reset) begin
            // Shift the 1 to the next bit position
            out <= {out[6:0], out[7]};
        end else begin
            // If reset is high, do nothing and keep the current state
        end
    end

    // Optional: Initialize the output to its starting state when the module is powered on
    initial begin
        out <= 8'b0000_0001;  // Set the LSB to 1
    end

endmodule