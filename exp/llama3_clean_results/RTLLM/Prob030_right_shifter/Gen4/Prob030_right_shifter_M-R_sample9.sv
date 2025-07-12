module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize the output register to 0
initial
    q = 8'd0;

// Update the output register on each rising edge of the clock
always @ (posedge clk)
    q <= {d, q[7:1]};  // Shift the current value of q to the right and insert d at the MSB

endmodule