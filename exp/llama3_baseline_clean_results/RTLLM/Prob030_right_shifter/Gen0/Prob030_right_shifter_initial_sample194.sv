module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q; // Register to hold the shifted bits

// Initialize the register q to 0
initial q = 8'd0;

// On each rising edge of the clock, shift the contents of the q register to the right by one bit
// and insert the new input bit d into the most significant position of the register
always @ (posedge clk) begin
    q[7:1] <= q[6:0]; // Shift the bits to the right
    q[0] <= d;       // Insert the new input bit into the least significant position
end

endmodule