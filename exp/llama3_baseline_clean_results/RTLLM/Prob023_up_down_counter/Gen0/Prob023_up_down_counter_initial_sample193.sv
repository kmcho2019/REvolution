module up_down_counter (
    input clk,      // Clock signal
    input reset,    // Reset signal
    input up_down,  // Control signal to determine counting direction
    output [15:0] count // 16-bit output representing the current counter value
);

reg [15:0] counter; // reg variable to hold the current count

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // If reset signal is active, reset the counter to zero
        counter <= 16'd0;
    end else begin
        // If up_down control signal is high, increment the counter
        if (up_down) begin
            counter <= counter + 1;
        end 
        // If up_down control signal is low, decrement the counter
        else begin
            counter <= counter - 1;
        end
    end
end

assign count = counter; // Assign the current count to the output port

endmodule