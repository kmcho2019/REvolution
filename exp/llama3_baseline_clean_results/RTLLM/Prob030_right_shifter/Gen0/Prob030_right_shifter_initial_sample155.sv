module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

initial q = 8'b0; // Initialize the q register to 0

always @(posedge clk) begin
    // Right-shift the contents of the q register by one bit
    // and insert the new input bit d into the most significant position of the register
    q <= {d, q[7:1]};
end

endmodule