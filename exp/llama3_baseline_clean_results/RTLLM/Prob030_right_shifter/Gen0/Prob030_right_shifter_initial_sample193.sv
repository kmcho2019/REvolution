module right_shifter (
    input clk,  // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // 8-bit register

// Initialize the q register to 0
initial q = 8'b0;

// Perform right shift operation on each rising edge of the clock
always @(posedge clk) begin
    // Shift the contents of the q register to the right by one bit
    q <= {d, q[7:1]};
end

endmodule