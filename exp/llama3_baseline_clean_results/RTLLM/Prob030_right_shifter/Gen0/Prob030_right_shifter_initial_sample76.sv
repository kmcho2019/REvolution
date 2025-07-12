module right_shifter(
    input clk,  // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Register to hold the result of the right shift operation

// Initialize q to 0
initial q = 8'd0;

// Perform right shift operation on rising edge of clock
always @(posedge clk) begin
    // Shift q to the right by 1 bit
    q <= {d, q[7:1]};
end

endmodule