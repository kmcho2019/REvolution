module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Define the register 'q' of size 8 bits

initial q = 8'd0;  // Initialize 'q' to 0

always @ (posedge clk) begin
    // Right-shift the contents of 'q' by one bit
    q <= {d, q[7:1]};
end

endmodule