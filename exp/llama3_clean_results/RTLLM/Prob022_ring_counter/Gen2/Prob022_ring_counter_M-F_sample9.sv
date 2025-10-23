module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // Counter to keep track of the current state (0 to 7)

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset counter to 0 when reset is high
        out <= 8'b0000_0001; // Initialize out to starting state
    end else begin
        if (counter == 7) begin // If counter is at its maximum value
            counter <= 0; // Reset counter to 0 for cyclic behavior
        end else begin
            counter <= counter + 1; // Increment counter on each clock pulse
        end
        // Set out based on the counter value using bitwise operations
        reg [7:0] temp; // Temporary variable to hold the shifted value
        temp = 1 << counter; // Shift 1 to the left by counter places
        out <= temp; // Assign the temporary variable to out
    end
end

endmodule