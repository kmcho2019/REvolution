// TopModule: A Mealy-type finite state machine that recognizes the sequence "101" on the input signal x.
module TopModule(
    input  clk,       // Clock signal
    input  aresetn,   // Asynchronous reset signal (active low)
    input  x,         // Input signal to detect the sequence "101"
    output z          // Output signal to indicate the detection of the sequence "101"
);

// Counter to track the transitions in the input signal
reg [1:0] counter;

// Previous value of the input signal
reg prev_x;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    // If reset is active, initialize the counter and previous value
    if (!aresetn) begin
        counter <= 2'b00;
        prev_x <= 1'b0;
    end else begin
        // Update the previous value
        prev_x <= x;

        // Update the counter based on the transitions in the input signal
        if (x == 1'b1 && prev_x == 1'b0) begin
            // Increment the counter when a '1' is detected after a '0'
            counter <= counter + 1'b1;
        end else if (x == 1'b0 && prev_x == 1'b1) begin
            // Decrement the counter when a '0' is detected after a '1'
            if (counter > 2'b00) begin
                counter <= counter - 1'b1;
            end
        end
    end
end

// Output logic: Assert z when the counter reaches the desired value
assign z = (counter == 2'b10);

endmodule