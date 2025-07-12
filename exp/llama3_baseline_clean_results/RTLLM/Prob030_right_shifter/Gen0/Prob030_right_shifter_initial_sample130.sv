module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q; // Register to store the current state of the shifter

// Initialize the q register to 0
initial q = 8'b0;

// Always block that runs on the rising edge of the clock
always @(posedge clk) begin
    // Right-shift the current state by one bit and insert the new input bit into the most significant position
    q <= {d, q[7:1]};
end

endmodule