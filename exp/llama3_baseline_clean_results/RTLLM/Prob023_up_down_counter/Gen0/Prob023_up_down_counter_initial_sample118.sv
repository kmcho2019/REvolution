module up_down_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    input up_down,  // Control signal to determine counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] counter;  // 16-bit register to store the current counter value

always @(posedge clk)  // Synchronous process triggered by the rising edge of the clock signal
begin
    if (reset)  // Check if the reset signal is active
    begin
        counter <= 16'd0;  // Reset the counter to zero
    end
    else  // If the reset signal is not active
    begin
        if (up_down)  // Check the value of the up_down control signal
        begin
            counter <= counter + 1;  // Increment the counter
        end
        else
        begin
            counter <= counter - 1;  // Decrement the counter
        end
    end
end

assign count = counter;  // Assign the current counter value to the count output port

endmodule