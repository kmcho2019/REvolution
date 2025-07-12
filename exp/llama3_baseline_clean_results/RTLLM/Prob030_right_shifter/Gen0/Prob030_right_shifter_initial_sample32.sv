module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize the q register to 0
initial q = 8'b0;

// Perform right shift on the rising edge of the clock
always @(posedge clk) begin
    // Shift the contents of the q register to the right by one bit and insert the new input bit d into the most significant position
    q <= {d, q[7:1]};
end

endmodule