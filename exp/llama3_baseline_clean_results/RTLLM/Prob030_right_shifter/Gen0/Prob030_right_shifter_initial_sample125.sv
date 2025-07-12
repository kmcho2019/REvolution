module right_shifter(
    input clk,  // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Register to hold the right-shifted value

// Initialize q to 0
initial q = 8'b0;

// Perform right shift on rising edge of clock
always @(posedge clk) begin
    // Shift q to the right by one bit and assign the most significant bit the value of d
    q <= {d, q[7:1]};
end

endmodule