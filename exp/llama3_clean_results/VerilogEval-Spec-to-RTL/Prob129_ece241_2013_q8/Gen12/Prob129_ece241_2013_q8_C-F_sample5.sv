// TopModule: A Mealy-type finite state machine that recognizes the sequence "101" on the input signal x.
module TopModule(
    input  clk,       // Clock signal
    input  aresetn,   // Asynchronous reset signal (active low)
    input  x,         // Input signal to detect the sequence "101"
    output z          // Output signal to indicate the detection of the sequence "101"
);

// Shift register to store the last two values of x
reg [1:0] last_two_bits;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    // If reset is active, initialize the shift register
    if (!aresetn) begin
        last_two_bits <= 2'b00;
    end else begin
        // Shift the bits and add the new input
        last_two_bits <= {last_two_bits[0], x};
    end
end

// Output logic: Assert z when the last two bits are "10" and the current input is "1"
assign z = (last_two_bits == 2'b10) && x;

endmodule