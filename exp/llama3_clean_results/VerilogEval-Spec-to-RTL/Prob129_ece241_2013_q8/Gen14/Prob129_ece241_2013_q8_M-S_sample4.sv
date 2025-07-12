// TopModule: A simplified Mealy-type finite state machine that recognizes the sequence "101" on the input signal x.
module TopModule(
    input  clk,       // Clock signal
    input  aresetn,   // Asynchronous reset signal (active low)
    input  x,         // Input signal to detect the sequence "101"
    output z          // Output signal to indicate the detection of the sequence "101"
);

// Shift register to store the last two values of x
reg [1:0] last_two_bits;

// Asynchronous reset and clock edge detection
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        // Reset the shift register
        last_two_bits <= 2'b00;
    end else begin
        // Update the shift register with the current input
        last_two_bits <= {last_two_bits[0], x};
    end
end

// Simplified output logic: Assert z when the sequence "101" is detected
assign z = (last_two_bits == 2'b10) && x;

endmodule