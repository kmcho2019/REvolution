module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0
initial q = 8'b0;

// Perform right shift operation on rising edge of clock
always @(posedge clk) begin
    // Shift q right by one bit and insert d into the most significant position
    q <= {d, q[7:1]};
end

endmodule