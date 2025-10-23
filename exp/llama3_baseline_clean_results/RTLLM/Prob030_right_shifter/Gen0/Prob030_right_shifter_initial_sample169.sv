module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize the register to 0
initial q = 8'b0;

// On each rising edge of the clock, shift the contents of the q register to the right and insert the new input bit into the most significant position
always @ (posedge clk) begin
    // Shift the register to the right by one bit
    q <= {d, q[7:1]};
end

endmodule