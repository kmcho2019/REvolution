module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Define an 8-bit register

// Initialize the register 'q' to 0
initial q = 8'd0;

// Perform the right shift operation on the rising edge of the clock
always @(posedge clk) begin
    // Shift the contents of 'q' one bit to the right and insert 'd' into the most significant bit
    q <= {d, q[7:1]};
end

endmodule