module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize the q register to 0
initial q = 8'b0;

// Always block sensitive to the rising edge of the clock
always @(posedge clk) begin
    // Right-shift the contents of q by one bit and assign the most significant bit to d
    q <= {d, q[7:1]};
end

endmodule