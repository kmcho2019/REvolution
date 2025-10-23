module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q; // Register to store the right shifted value

// Initialize the q register to 0
initial q = 8'b0;

// On each rising edge of the clock, right shift the q register by one bit
// and insert the new input bit d into the most significant position of the register
always @(posedge clk) begin
    // Right shift the q register by one bit
    q <= (q >> 1);
    // Insert the new input bit d into the most significant position of the register
    q[7] <= d;
end

endmodule