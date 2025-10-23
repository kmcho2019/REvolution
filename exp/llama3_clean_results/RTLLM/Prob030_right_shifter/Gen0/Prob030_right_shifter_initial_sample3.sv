module right_shifter (
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Register to store the shifted bits

// Initialize q to 0
initial q = 8'b0;

// Perform right shift on rising edge of clock
always @(posedge clk) begin
    // Shift the contents of q to the right by 1 bit
    q <= {d, q[7:1]};  // d is assigned to q[7], and q[7:1] is shifted to the right
end

endmodule