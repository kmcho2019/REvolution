module right_shifter(
    input clk, // clock signal
    input d,   // input signal to be right-shifted
    output reg [7:0] q  // output signal representing the result of the right shift operation
);

// Initialize the q register to 0
initial
    q = 8'b0;

// Shift the contents of q to the right by one bit and insert the new input bit d into the most significant position on each rising edge of the clock
always @(posedge clk)
begin
    // Shift the bits of q one position to the right
    q <= {d, q[7:1]};
end

endmodule